# Lale.Help

[![Circle CI](https://circleci.com/gh/lale-help/lale-help.svg?style=svg)](https://circleci.com/gh/lale-help/lale-help)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A collaborative platform for volunteer refugee support. Lale.Help enables communities to self-organize into **Circles**, coordinate tasks and supplies, and manage volunteers through structured working groups.

**Live at:** [lale.help](https://lale.help)

---

## Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Docker (Recommended)](#docker-recommended)
  - [Native macOS](#native-macos)
- [Development](#development)
  - [Environment Variables](#environment-variables)
  - [Background Jobs](#background-jobs)
  - [File Uploads](#file-uploads)
  - [Email](#email)
  - [Custom Icons](#custom-icons)
  - [JavaScript Dependencies](#javascript-dependencies)
- [Testing](#testing)
- [Internationalization (I18N)](#internationalization-i18n)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Lale.Help helps refugee support communities coordinate volunteer work. The core organizational model is:

```
Circle  (a community or organization)
└── WorkingGroup(s)  (teams within a circle)
    ├── Task(s)      (volunteer work items with sign-up)
    ├── Supply(ies)  (resources to be sourced or donated)
    └── Project(s)   (longer-running initiatives with timelines)
```

Users join Circles with roles (**admin**, **official**, **volunteer**, **leadership**) and can participate across multiple working groups and tasks.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 2.x |
| Framework | Rails 4.2 |
| Database | PostgreSQL |
| Web Server | Puma |
| Background Jobs | Sidekiq + Redis |
| File Storage | Refile + AWS S3 |
| Email Delivery | Mandrill API |
| Authorization | CanCanCan |
| Authentication | OmniAuth (email/password via omniauth-identity) |
| Admin UI | ActiveAdmin |
| Templates | Slim |
| CSS | Sass + Bourbon + Neat |
| JavaScript | CoffeeScript + Handlebars + Turbolinks |
| UI Components | Cells (ViewComponent pattern) |
| Geocoding | Geocoder |
| PDF Export | WickedPDF + wkhtmltopdf |
| Deployment | Heroku |

---

## Architecture

### Mutations (Service Objects)

Business logic lives in **mutation** classes (`app/mutations/`) using the [`mutations` gem](https://github.com/cypriss/mutations), not in controllers or models. This keeps controllers thin and logic testable.

```ruby
# Example: volunteer signs up for a task
outcome = Task::Volunteer.run(task: @task, user: current_user)

if outcome.success?
  redirect_to task_path, notice: "You've signed up!"
else
  render :show, alert: outcome.errors.message_list
end
```

Mutation namespaces mirror the domain: `task/`, `circle/`, `working_group/`, `project/`, `supply/`, `comment/`, `file_upload/`, `sponsor/`, `authentication/`, `token_handlers/`.

### Authorization

CanCanCan drives authorization. Abilities are defined per role and checked in controllers:

```ruby
authorize! :manage, current_circle
```

Role statuses (`active` / `blocked`) apply across all role types: `CircleRole`, `WorkingGroupRole`, `TaskRole`, `SupplyRole`, `ProjectRole`.

### Domain Models

Key models and their relationships:

- **User** — has one identity (email/password), belongs to circles via roles
- **Circle** — top-level org unit; has an address, notification settings, working groups, sponsors
- **WorkingGroup** — subdivision of a circle; can be private; has tasks, supplies, projects
- **Task** — work item; supports five duration types (`1_hour`, `half_day`, `full_day`, `multiple_days`, `ongoing`); tracks required volunteers, shortfall detection, and skills
- **Supply** — resource item; tracks completion state
- **Project** — initiative with start/end dates
- **Token** — expiring tokens for passwordless login and invite flows

### Key Routes

```
/login, /logout, /register
/circles/:circle_id/
  ├── tasks         (create, volunteer, assign, complete, reopen, clone...)
  ├── supplies
  ├── projects
  ├── working_groups
  ├── members       (activate, block, comment)
  ├── admins
  ├── invitations
  └── documents
/user/accounts
/user/identities
/admin             (ActiveAdmin)
/sidekiq           (job dashboard, HTTP Basic Auth)
```

---

## Getting Started

### Docker (Recommended)

1. Install [Docker](https://www.docker.com/) for your OS.

2. Clone the repository:
   ```sh
   git clone https://github.com/lale-help/lale-help.git
   cd lale-help
   ```

3. Copy the example environment file:
   ```sh
   cp .env.example .env
   ```

4. Start the application:
   ```sh
   ./docker/start
   ```

5. In a second terminal, set up the database:
   ```sh
   ./docker/db-migrate
   ```

6. Open [http://localhost:5000](http://localhost:5000) in your browser.

#### Docker Scripts Reference

| Action | Command |
|---|---|
| Start Rails and services | `./docker/start` |
| Open Rails console | `./docker/rails-console` |
| Run RSpec tests | `./docker/rspec [path/to/spec]` |
| Run database migrations | `./docker/db-migrate` |
| Run a one-off command | `./docker/exec COMMAND` |
| Open a shell in the web container | `./docker/shell` |
| Inspect the DB with psql | `./docker/psql` |
| View logs from all services | `./docker/logs` |
| Stop all services | `./docker/stop` |
| Rebuild the web container | `./docker/build` |
| Reset Docker environment (destructive) | `./docker/reset` |
| Restore DB from snapshot | `./docker/restore-db-from SNAPSHOT_NAME` |

#### Docker FAQs

- **Where is Rails running?** Inside a Docker container. On macOS/Windows it is inside a Linux VM (via VirtualBox); on Linux it runs directly.
- **How do I access email sent by the app?** Visit [http://localhost:5000/letter_opener](http://localhost:5000/letter_opener)
- **Something broke overnight?** Try `./docker/reset`, then file an issue if it persists.
- **Running on Windows?** Note that `./docker/rspec` may not work on Windows.

### Native macOS

1. Ensure you have Ruby (see `.ruby-version`), PostgreSQL, and Redis installed.

2. Clone the repo and install dependencies:
   ```sh
   git clone https://github.com/lale-help/lale-help.git
   cd lale-help
   bundle install
   ```

3. Copy and configure the environment file:
   ```sh
   cp .env.example .env
   # edit .env with your local DB credentials etc.
   ```

4. Set up the database:
   ```sh
   bin/rake db:create db:migrate
   ```

5. Start the server:
   ```sh
   bin/rails server
   ```

6. Open [http://localhost:3000](http://localhost:3000).

---

## Development

### Environment Variables

All configuration is done via environment variables. Copy `.env.example` to `.env` and fill in values for:

- `DATABASE_URL` — PostgreSQL connection string
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `S3_BUCKET` — file uploads
- `MANDRILL_API_KEY` — email delivery
- `REDIS_URL` — Sidekiq background jobs
- `SECRET_KEY_BASE` — Rails secret

### Background Jobs

Lale uses [Sidekiq](https://github.com/mperham/sidekiq) for background job processing (primarily email delivery). Sidekiq requires Redis.

- **Admin UI:** [/sidekiq](http://localhost:3000/sidekiq) (HTTP Basic Auth protected)
- **Free Redis tier:** 30MB limit on Redis Cloud; configured with `allkeys-lru` eviction

To start Sidekiq locally (native setup):
```sh
bundle exec sidekiq
```

### File Uploads

Files are stored via [Refile](https://github.com/refile/refile) with S3 backend in production and local storage in development. Image processing uses MiniMagick.

Configure S3 credentials in `.env`. For local development, uploads are stored in `tmp/uploads`.

### Email

In development, emails are intercepted by [Letter Opener Web](https://github.com/fgrehm/letter_opener_web) and viewable at [/letter_opener](http://localhost:3000/letter_opener).

In production, emails are delivered via [Mandrill](https://mandrillapp.com). Set `MANDRILL_API_KEY` in your environment.

### Custom Icons

Custom SVG icons are stored in `app/assets/icons/`. After adding or modifying icons, regenerate the icon font:

```sh
fontcustom compile
```

Requires the [fontcustom gem](https://github.com/FontCustom/fontcustom) and its dependencies. See `config/fontcustom.yml` for configuration.

### JavaScript Dependencies

JavaScript packages are managed with [Bower](https://bower.io):

```sh
cd vendor/assets
bower install package_name --save
```

After installing, require the relevant JS/CSS files in `app/assets/javascripts/application.js` or `app/assets/stylesheets/application.css.scss`.

---

## Testing

Lale uses RSpec with Capybara for feature (integration) tests, and standard RSpec for unit tests.

### Running Tests

```sh
# Docker
./docker/rspec                               # all tests
./docker/rspec spec/features/tasks/          # specific directory
./docker/rspec spec/features/foo_spec.rb:42  # specific line

# Native
bin/rake spec
bin/rake SPEC=spec/features/your_spec.rb
```

### Test Stack

| Tool | Purpose |
|---|---|
| [RSpec](https://rspec.info) | Test framework (BDD-style) |
| [Capybara](https://github.com/teamcapybara/capybara) | Browser interaction DSL |
| [Poltergeist](https://github.com/teampoltergeist/poltergeist) | Headless WebKit driver (default) |
| [Selenium](https://www.selenium.dev) | Full browser driver (opt-in via `SELENIUM=1`) |
| [FactoryGirl](https://github.com/thoughtbot/factory_girl) | Test data factories |
| [Site Prism](https://github.com/natritmeyer/site_prism) | Page object DSL |
| [Timecop](https://github.com/travisjeffery/timecop) | Time freezing |
| [VCR](https://github.com/vcr/vcr) + [WebMock](https://github.com/bblimke/webmock) | HTTP stubbing |
| [DatabaseCleaner](https://github.com/DatabaseCleaner/database_cleaner) | DB state between tests |

### Feature Spec Guidelines

Feature specs live in `spec/features/`, page objects in `spec/page_objects/`.

**Structure:**
```ruby
describe "Create a task", js: true do
  context "when required fields are filled" do
    it "creates the task" do
      # assertions
    end
  end

  context "when form is submitted empty" do
    it "shows validation errors" do
      # assertions
    end
  end
end
```

**Best practices:**
- One use case per spec file; use expressive filenames (`join_working_group_spec.rb` not `working_group_spec.rb`)
- Start tests on the target page — do not navigate from the home page unless navigation is what you are testing
- Use page objects to encapsulate CSS selectors — see `spec/page_objects/_components/`
- Assert dynamic factory values, not hardcoded strings
- Use the [backdoor](spec/support/backdoor.rb) for login instead of the sign-in form in most tests
- Use traits for flexible factory composition: `create(:task, :completed, :with_volunteer)`
- Write factory tests for non-trivial factories in `spec/factory_specs/`

**Debugging failures:**
- Screenshots auto-saved to `tmp/capybara/` on failure
- Use `save_and_open_page` or `show!` for manual snapshots
- Use `Capybara.pry` for an interactive shell in the browser context
- Check `log/test.log` for Rails-level errors

For a detailed guide on writing and debugging feature specs, see [README_FEATURES_SPECS.md](README_FEATURES_SPECS.md).

---

## Internationalization (I18N)

All user-facing strings are stored in locale files under `config/locales/`. The frontend also uses `i18n-js` for JavaScript translations.

**Rules:**
- Translate complete sentences — do not concatenate translation fragments, as word order varies by language
- Never pluralize in Ruby; use Rails' `count:` parameter so the i18n framework applies language-specific rules:
  ```ruby
  I18n.t('tasks.volunteers_needed', count: 3)
  ```
- Date, time, and number formats belong in locale files too, not hardcoded in views

See the [Rails I18n Guide](http://guides.rubyonrails.org/i18n.html) for full documentation.

---

## Deployment

All environments are hosted on Heroku. Deploy using the provided script:

```sh
bin/deploy staging
bin/deploy demo
bin/deploy production
```

This deploys the current `master` branch and runs any pending migrations.

### Environments

| Environment | URL | Purpose |
|---|---|---|
| production | [lale.help](https://lale.help) | Live application |
| staging | [staging.lale.help](https://staging.lale.help) | Feature review and testing |
| demo | [demo.lale.help](https://demo.lale.help) | Demonstrations |
| development | http://localhost:3000 | Local development |

### Logs

```sh
heroku logs --tail --app lale-help-production
```

For historical logs, use the Papertrail add-on via the Heroku dashboard.

---

## Contributing

1. Fork the repository and create a feature branch from `master`
2. Write tests for any new behavior (see [Testing](#testing) above)
3. Ensure the full test suite passes
4. Submit a pull request with a clear description of the change

Report bugs and request features via [GitHub Issues](https://github.com/lale-help/lale-help/issues).

Further documentation is on the [project wiki](https://github.com/lale-help/lale-help/wiki).

---

## Styleguide

A component styleguide is available at [/styles](https://staging.lale.help/styles).

---

## License

This project is released under the [MIT License](LICENSE).
