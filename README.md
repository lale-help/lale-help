# Lale.Help

[![Circle CI](https://circleci.com/gh/lale-help/lale-help.svg?style=svg)](https://circleci.com/gh/lale-help/lale-help)

This is the rails application used for lale.help.

# Table of contents

<!-- MarkdownTOC depth=1 autolink=true bracket=round -->

- [Development hints for docker](#development-hints-for-docker)
- [URLs](#urls)
- [Internationalization \(I18N\)](#internationalization-i18n)
- [Restoring the database from a snapshot](#restoring-the-database-from-a-snapshot)
- [Advice for writing feature specs](#advice-for-writing-feature-specs)
- [Styleguide](#styleguide)
- [Environments and deployment](#environments-and-deployment)
- [Further documentation](#further-documentation)
- [License](#license)

<!-- /MarkdownTOC -->


## Development hints for docker

You can run Lale on your development machine using one of two methods:

1. on the native OS *(easy to set up on a Mac, setup used by the last 2 core developers)*
1. running in a Linux container using [Docker](https://www.docker.com/) *(recommended for Rails beginners)*

### Standard Rails Project


### Docker Project

Before you do anything, install [Docker](http://www.docker.com/) for your OS.

When working with docker, there are many scripts found in the `docker` folder to help you get started.
Feel free to read through these scripts to understand what Docker and Docker Compose are doing under
the hood to start the rails application

#### Starting Rails
  To run the rails server, just execute the following script on your development machine.

  `./docker/start`

  This starts rails and the associated services (PostgreSQL, etc...) in the background with docker.
  To view the rails logs, you can use `./docker/logs`


#### Docker Scripts
| Script Description                         | How to run                            |
|--------------------------------------------|---------------------------------------|
| Start Rails (and other services)           | `./docker/start`                      |
| Open a Rails console                       | `./docker/rails-console`              |
| Run Tests                                  | `./docker/rspec [/path/to/spec]`      |
| Migrate the DB                             | `./docker/db-migrate`                 |
| Run a one off command in the web container | `./docker/exec COMMAND`               |
| Run bash on the web container              | `./docker/shell`                      |
| Inspect the DB with psql                   | `./docker/psql`                       |
| View the logs from every service           | `./docker/logs`                       |
| Stop all services                          | `./docker/stop`                       |
| Rebuild the web container                  | `./docker/build`                      |
| Reset your Docker environment              | `./docker/reset`                      |

### Adding icons to the lale iconfont

We use a custom font to combine our icons into one file, in order to save bandwith and HTTP requests. The icons are stored in `app/assets/icons` and need to be in SVG format, the (generated) font files are in `app/assets/fonts/lale/lale.*. 

Run the command `fontcustom compile` to update the font file after changing anything in the icons directory. The [fontcustom gem](https://github.com/FontCustom/fontcustom/) needs to be installed separately, it is not contained in the gem file. See the configuration file [config/fontcustom.yml](config/fontcustom.yml) for details.

### Adding JavaScript packages / dependencies

We use [bower](https://bower.io) to manage complex JS dependencies. Do the following to add a new JS dependency:

```
cd vendor/assets
bower install package_name --save
```

Then use the package documentation to understand which JS and CSS files you need to require, find them in `vendor/assets/bower_components/package_name` and require them in `app/assets/javascripts/application.js` or `app/assets/stylesheets/application.css`.

#### Known issues

  * If you are using Windows the Run tests command above does not work.

#### FAQs

  * Where is Docker running?
    * Developing on OS X or Windows: Docker is running inside of a linux virtual machine, probably managed by VirtualBox.
    * Developing on Linux (Ubuntu, etc): Docker is likely running directly on you development machine
  * Where is Rails and PostgreSQL running?
    * Each of these services are running in separate containers on your Docker machine.
  * Where does rspec run?
    * We are sharing the container that is running the main rails process.
  * How do I run an rake/rails command?
    * first, log into the web container: `./docker/shell`
    * then run whatever you would like :)
  * Things were working yesterday but all of a sudden everything is broken. What do I do?
    * First try run and run `./docker/reset`
    * if that fails file a GitHub issue
  * How do I open the local UI?
    * go to http://\<DockerIP\>:5000/
  * How do I look at email sent by the app?
    * go to http://\<DockerIP\>:5000/letter_opener

## URLs

* production: [lale.help](https://lale.help)
* demo: [demo.lale.help](https://demo.lale.help)
* staging: [staging.lale.help](https://staging.lale.help)
* development (default) http://localhost:3000/

## Internationalization (I18N)

Some advice:

* Since it should be easy to offer lale in a new language, we are using Rails' built in internationalization framework. It is mature and well documented [here](http://guides.rubyonrails.org/i18n.html), please review it if you're not up to date.

* using the i18n framework means all **strings and translations** should be stored in locale files in `config/locales`. The same goes for **date**, **time** and **number formats**. 

* be aware not to build one sentence from several smaller translations, because that hard-codes a certain sentence structure, which may not be the same in every language. Always translate complete sentences, or at least ensure that words of a sentence can be in arbitrary order.

* don't pluralize words in Ruby code, as pluralization rules can be different. Slavic languages have two plural forms, for example: the word "apples" will be differnt in "two apples" and "five apples". Rails i18n can handle that with it's built in [i18n rules](https://goo.gl/BGY6KC) if you take advantage of the feature (pass `count: number` to `I18n.t`).

## Restoring the database from a snapshot

``` sh
# in one terminal tab
docker-compose up

# in another terminal tab
cp /path/to/database/snapshot/SNAPSHOT_NAME .
./docker/restore-db-from SNAPSHOT_NAME
```

## Advice for writing feature specs

### Description

[Feature spec](https://www.relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec) is the most common name in Rails projects for tests of the whole application through the web browser. Feature specs are in the [`spec/features`](https://github.com/lale-help/lale-help/tree/master/spec/features) directory.

### Overview of the testing tools lale uses

* [rspec](http://www.relishapp.com/rspec/): a general purpose, BDD (behaviour driven development) framework for describing, structuring, executing tests, provides assertions, etc. It's the most common Ruby testing framework.

* [Capybara](http://jnicklas.github.io/capybara): provides a DSL and abstraction layer for writing browser-based tests. In lale, it is configured to use the poltergeist driver by default, but Selenium can be turned on alternatively.

* [poltergeist](https://github.com/teampoltergeist/poltergeist): Is a Capybara-driver that uses a headless WebKit browser to use the application and execute the tests.

* [FactoryGirl](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md): a powerful tool to define factories for your test setup (seed) data.

* [site_prism](https://github.com/natritmeyer/site_prism): "A Page Object Model DSL for Capybara". Lets you define page objects to abstract and reuse access to the various HTML pages (screens) of the application.

All of these are standard Ruby/Rails gems (libraries) and can be found on GitHub.

### Pros and cons of feature specs

This summary should help to understand the decisions and following advice of lale's feature spec setup.

#### Pros

1. **completely decoupled** from the actual Ruby system. They use the HTML page as the interface to the application, this allows refactoring the Ruby code without any changes in the spec. 

2. they are **high-level** and written with the RSpec BDD framework, so they document well what lale is expected to do, in nontechnical language.

3. **high confidence** since they test the whole system and behave very similar to a real user, if the test passes it is very likely that the feature under test actually works as expected.

#### Cons:

1. **very slow**: a feature spec typically takes a few orders of magnitude longer to run than a unit test. Thus feedback is much slower. If no care is taken, the test suite runtime can easily exceed the patience of developers, which leads to neglection of these tests.

2. **maximum complexity of the system under test**: since they are executed against the full, integrated system stack, there are seemingly infinite possibilities for things going wrong. So these tests can sometimes be tedious and unpredictable to write.

3. **can fail intermittently, seemingly non-deterministically** mainly because of the system and setup complexity. Three processes/threads are involved (test, browser, Rails server). Page load times vary from test to test and system load, so timing issues can arise. 

4. **can fail on minor HTML/CSS changes** feature specs use CSS selectors to navigate and access the content of the HTML pages. When those are changed the tests fail, despite the feature still working.

5. **complex seed data setup** in order to do interesting things on lale, most of the time you need at least a user, a circle, a working group and the roles to relate them to each other correctly. This can be difficult to set up by hand for each test.

### Dealing with the pros and cons

### Prepare yourself for things not always going smoothly

    "Unfortunately, the nature of full-stack testing is that things can and do go wrong from time to time."
    -- https://github.com/teampoltergeist/poltergeist#troubleshooting

* _sometimes_ things will not work as expected and you have no idea why. Debugging sessions can be huge time sinks with seemingly no progress. Accept it, and use the many tools & techniques described here to deal with it.

* Timebox a debugging session, and put an imperfect/partial/messy test in place if you can, rather than no test at all. 

* Stop debugging when you're exhausted/frustrated and get something else done. Retry with a fresh, calm mind on the next morning. Often you paint yourself into a corner when debugging for too long, and you'll quickly find the problem with a new approach on the next attempt.

* Show/explain the test to another developer (or a [rubber duck](https://en.wikipedia.org/wiki/Rubber_duck_debugging)) and debug together.
 
* Sometimes you'll have to disable a spec that fails intermittently until you get a change to debug it thoroughly (use the :skip or :ci_ignore flags described below).

### Reduce test complexity, increase test robustness

* don't test more than one use case per file (for example: one test to check the contents of a working group dashboard, one test for joining/leaving a working group). Different use cases usually require different setup and steps, so the test file gets long, setup gets complex and hard to follow if several features are tested, which can cause bugs.

* use expressive filenames related to the use case if possible. So rather than `show_working_group_spec.rb` use `show_working_group_dashboard_spec.rb` and `join_and_leave_working_group_spec.rb`. It will be much easier to navigate and autocomplete the spec filenames compared to having 50 `create_spec.rb` files!

* don't abstract and generalize test code/methods too agressively. It should always be easy to read and understand a test.

* don't make CSS selectors more specific than they need to; ideally you're using components selectors which are indepentent of the surrounding page.

* if possible, minimize technical complexity of the system under test to minimize runtime and the number of things that can go wrong. Stub nonessential systems that you can test individually in separate integration tests (Email, external APIs, ...)

* use [page objects](http://martinfowler.com/bliki/PageObject.html) to 
  * create nice interfaces to the tested HTML pages and the parts you are interested in
  * maintain the CSS selectors for one page (or page component) in one place
  * create helper methods and custom rspec [predicate matchers](https://www.relishapp.com/rspec/rspec-expectations/v/3-5/docs/built-in-matchers/predicate-matchers) that simplify testing. For example:

```ruby
# in spec. through rspec's magic, this will call task_page.has_helper?(admin)
expect(task_page).to have_helper(admin)

# in the page object
elements :users, '.user-name-shortened'
# [...] 
def has_helper?(user_to_find)
  users.any? { |user| user.text == user_to_find.name }
end
```

[Our page objects](https://github.com/lale-help/lale-help/tree/323c94b1195272d81889dbe8a8d407ee0ae15a71/spec/page_objects) are based on the excellent [site_prism](https://github.com/natritmeyer/site_prism) gem.

* don't put assertions directly in page objects, to keep the objects generic. Implement generic helper methods (`#has_helper?` `#completed?`) in them instead, which can be reused in different specs (also see example above).

* when interaction with one page leads to another page, have the page object return an instance of the new page object. That way you don't have to set things up in the spec file. Have a look at the form specs for examples.

* assert strings by comparing the dynamic value obtained from the HTML page to the dynamic value from the factory created object, rather than hard-coding strings in every spec. The probability of our factories returning empty strings or nil values is very low, and we actually care that the values match, not that they are a certain string.

* when developing features and writing tests, try to identify and create reusable HTML/CSS components (see `app/assets/stylesheets/components` for examples). These only need to be written once and can then be reused. Often tests can be copy/pasted and slightly adapted if components are reused.

* when using components ("sections") in page objects, don't access them directly from the test. Instead delegate to it from the page object. Have a look at the components in `spec/page_objects/_components` and how they are used to understand.

* use [advanced / CSS3 selectors](http://www.w3schools.com/cssref/css_selectors.asp), like [:nth-of-type()](http://www.w3schools.com/cssref/sel_nth-of-type.asp) to find elements. They are faster to write/adapt than accessing the data you're interested in with Ruby, or adding extra classes to the HTML page.

* when testing time relevant stuff, consider freezing time with the [timecop](https://github.com/travisjeffery/timecop) gem.

* don't assert every detail of a page, assert what's essential. The more assertions, the more likely some of that will change in the future, requiring the test to be adapted.

* use rspec's BDD (behaviour driven development) approach to help yourself to structure a test, and help yourself and others to understand it later:
  * Use `describe` blocks to describe the variation of the feature you're testing, 
  * `context` blocks to describe the preconditions of the contained test(s). Context blocks usually begin with `"when ..."`. They help you figure out which precontions/setup code to write.
  * A context-block will usually contain only one `it` block, which describes the expected outcome. Often the it block will contain almost only assertions.

This structure is verbose, but it improves test accessibility and thus maintainabilty.

Examples:

```ruby
describe "Create a task", js: true do
  context "when only required fields are filled" do
    it "creates the task" do
      ...
    end
  end
  context "when form is submitted empty" do
    it "shows all error messages" do
      ...
    end
  end
end
```

```ruby
describe "Join and leave a working group", js: true do
  describe "joining a group" do
    context "when use has not joined yet" do
      it "becomes member of the group" do
        ...
      end
    end
  end
end
```

### Developing and debugging efficiently

#### General development tips

* testing selectors: use jQuery in the browser console to test the CSS selectors you want to use. It's much faster that way than to execute the test every time until you got the selector right. (slight gotcha: in rare cases jQuery selectors may not work with Capybara, since they use different CSS engines ([Sizzle](https://sizzlejs.com/) vs. [Nokogiri](http://www.nokogiri.org/)).

* write and use [powerful, expressive, flexible factories](https://github.com/lale-help/lale-help/blob/master/spec/factories/circles.rb) to easily set up the seed data required for the test. Expressive factories also help understanding the setup quickly.

Compare:

    let(:circle)        { create(:circle, :with_admin_and_working_group) }
    let(:admin)         { circle.admin }
    let(:working_group) { circle.working_groups.first }

to:

    let(:circle)        { create(:circle) }
    let(:circle_role)   { create(:circle_admin_role, circle: circle) }
    let(:user)          { circle_role.user }
    let(:working_group) { circle.working_groups.first }
    let(:working_group_role) { create(:working_group_volunteer_role, working_group: working_group, user: user) }

Consider abstracting details you don't care about, example:

    let(:group)         { create(:working_group, members: 2) }

* default factories: should create all objects the main object needs to be valid and work properly. Examples: `create(:working_group)` creates a circle for that contains the working group, `create(:circle_admin_role)` creates a circle and an admin user.

* use an existing spec as a scaffold for your new test (copy & paste to new file, adapt) to speed up things. Consider using generic but fitting variable names ('inputs' instead if 'supply_inputs', etc.) to make copying easier. Factor out things when you notice frequent repetition, though.

* which scenarios to test for a feature (ordered by priority):
  1. successfully using the feature ([happy path](https://en.wikipedia.org/wiki/Happy_path))
  1. one/main error or variation of the feature
  1. main variations of the feature
  1. navigating to the feature (navigating to the feature should not be part of a regular test; start on the feature page)
  - an example for creating tasks:

    1. fill and submit form with minimum required valid inputs
    1. fill and submit form with invalid inputs (empty form submit)
    1. fill and submit form with maximum possible inputs
    1. navigate to the create task form (from different places)

  - in each test, focus on testing that the important parts of a page are displayed correctly, rather than testing all edge cases through feature specs. The feature spec makes sure the feature can be 
    1. used/accessed as expected and 
    1. the result of the unit/model/mutation/controller interaction is displayed correctly.

  For testing the edge cases, use faster unit/model/mutation/controller tests. 

* keep the tests for elements and logic that appear(s) on multiple pages as [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) as possible.Write only one test for something that repeats on several pages if you know the technical implementation is very similar. A slight chance remains that the feature will not work in the untested cases. But the alternatives (duplicating test code and/or factoring it out with rspec's shared examples or helper methods) quickly increases spec runtimes and complexity. Specs should be simple to understand and change.

#### Debugging

* look at the screenshots in `tmp/capybara` that are created automatically at every test failure (we use the capybara-screenshot gem for that). The path to the file is linked in the test output as well. Create a screenshot manually with `show!` or `save_and_open_page` to inspect an image/the HTML of the page at any time step.

* use `Capybara.pry` to start a shell / debugger in the context of the page. From there, use standard capybara API to inspect the page (like `find('some-css-selector')`). Type `exit` to let the spec continue.

* often incorrect system setup issues cause errors. When things aren't working as you expect, put assertions in your test that ensure the test data is set up as expected, like `expect(working_group.organizer).to eq(my_user)`. You can mitigate these with reliable factories and tests for them, though.

* write [tests for non-trivial factories](https://github.com/lale-help/lale-help/blob/master/spec/factory_specs/circles_factory_spec.rb) (sic!!!). Wrong seed data is a frequent source of errors in specs, you can rule them out completely this way. Learn about the more advanced features of factory_girl [here](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md), and prefer [traits](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#traits) to factory inheritance for sets of attributes / kinds of objects, since they can be combined independently. Example: 

```ruby
let(:completed_task) { create(:task, :completed, :with_volunteer) }
```

* look at the Rails application log to understand what's going on, insert normal debug messages in your code.

* use `evaluate_script('some js code')` to evaluate javascript in the context of the current HTML page, sometimes very useful for inspection. 

* use [poltergeist's remote debugging feature](https://github.com/teampoltergeist/poltergeist#remote-debugging-experimental) to open the page you're testing in a DOM inspector.

* [some more valuable hints here](https://quickleft.com/blog/five-capybara-hacks-to-make-your-testing-experience-less-painful/), like fixing trouble with DatabaseCleaner and database transactions, easily pausing the test and browsing the page. [Here's](http://ricostacruz.com/til/pausing-capybara-selenium.html) an untested hint on how to pause Capybara tests for DOM inspection when using Selenium.

* debugging intermittently failing tests: use the following loop in bash to run your spec endlessly. If you're lucky, the spec will fail from time to time as well. In that case, inspect the logs (Rails log, Capybara debug log), inspect the database state and compare the differences.

```
while true; do bin/rake SPEC=spec/features/your/spec/file.rb:line_nr; sleep 1; done
```

Only run one test in isolation (give the test file name and line number) to prevent possible side effects. 

Since the test runs over and over again you can change/debug the code continuously.

If the spec never fails when run in isolation, start adding more and more test files to the run until you get the fails. Then start removing specs until you get a stable test again. That way you'll find the other test that makes your test fail.

If the spec only fails in CircleCI, use their "Rebuild with SSH" feature (alternate option of the 'Rebuild' button on the build page) to inspect the state of the CI server online. If you can't get them to run, set `:ci_ignore`on the it block to ignore the spec only in CI.

Try overloading the system with other processes (endless loops) to slow down the Rails application and thus reproduce the timing issues more often.

Review the test, application code and setup thoroughly. Sometimes you have a piece of code that returns variable results (options in a select field ordered differently, etc.)

Insert a `sleep 2` before the command that fails. When you're sure that's the issue, convert it to a `wait_for_$element_name$` [command to be more robust](https://github.com/natritmeyer/site_prism#waiting-for-an-element-to-exist-on-a-page). It waits for the  element to show up on the page. Don't leave `sleep`commands in the code, as they slow down the spec execution and are never 100% reliable, as the wait times for something to happen can be unpredictable, especially when specs are parallelized on a machine.

### Running tests faster

* use the [spring](https://github.com/rails/spring) Rails application preloader to shave 5-10 seconds off the test runtime. It's set up already, just use the wrapper scripts in the `bin` directory, like `bin/rake spec:features`. Be aware changes to Rails configuration and similar may need a restart to take effect.

* use the [poltergeist](https://github.com/teampoltergeist/poltergeist) test driver as default, it uses a headless Webkit browser engine (PhantomJS) and is significantly faster than Selenium. lale is set up that way already. Switch to back to Selenium if you want to follow the test steps in the browser. Use `SELENIUM=1` on the command line to use it.

* use the [backdoor](https://github.com/lale-help/lale-help/blob/master/spec/support/backdoor.rb), rather than logging in a user through the sign in form for every test. Make sure to have separate sign-in specs, though!

* start the test on the page you want to test rather than navigating there from another page. Write separate, simple tests to navigating to the feature, once, if you care about it.

* contrary to best practise for unit tests, run **multiple** assertions per test. test everything that can be tested for the data setup you just tediously built.

* run only one test or subsets of them with: `bin/rake SPEC=path/to/spec/file/or/directory`

* parallelize tests, i.e. run subsets of tests in separate processes in parallel. This puts a lot of load on the test machine though and may produce more timing issues (leading to intermittent test failures) on insufficient hardware.

## Styleguide

A first version can be found at the path [/styles](https://staging.lale.help/styles)

## Environments and deployment

All lale environments are hosted on heroku. Use the script `bin/deploy {environment-name}` to deploy the latest code (master) and run migrations.

### staging

For testing/reviewing new features, bugfixes, change requests. Deploy whenever a new feature is ready or requires feedback.

### demo

Do a new release when production is released, or when requested.

### production

Do a new release when requested.

Deploy 
## Further documentation

... can be found on [the wiki](https://github.com/lale-help/lale-help/wiki)

## License

This project uses the [MIT License](https://github.com/lale-help/lale-help/blob/master/LICENSE).
