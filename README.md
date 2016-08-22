# Lale.Help

[![Circle CI](https://circleci.com/gh/lale-help/lale-help.svg?style=svg)](https://circleci.com/gh/lale-help/lale-help)

This is the rails application used for lale.help.

# Table of contents

<!-- MarkdownTOC depth=2 autolink=true bracket=round -->

- [Development hints for docker](#development-hints-for-docker)
- [URLs](#urls)
- [Internationalization \(I18N\)](#internationalization-i18n)
- [Restoring the database from a snapshot](#restoring-the-database-from-a-snapshot)
- [Advice for writing feature specs](#advice-for-writing-feature-specs)
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

[_"Feature spec"_](lale-help/lale-help/tree/master/spec/features) is the most common name in Rails projects for a system integration test that is executed through the web browser. Feature specs are in the `spec/features` directory.

### Pros and cons of feature specs

I'm summarizing these here because they help understanding some decisions I took for lale's feature specs setup.

#### Pros

1. **completely decoupled** from the actual Ruby system. They use the HTML page as the interface to the application, this allows refactoring the Ruby code without any changes in the spec. 

2. they are **very high-level** and written with the RSpec BDD framework, so they document quite well what lale is expected to do, in nontechnical language.

3. **high confidence** since they test the whole system and behave very similar to a real user, if the test passes it is very probable that the feature under test actually works.

#### Cons:

1. **very slow**: feature specs take 1-2 orders of magnitude longer to run than a unit/model test. Thus feedback is much slower. Test suite runtimes can easily exceed the patience of the average programmer, which can lead to neglection of this kind of tests.

2. **maximum complexity of the system under test**: since these tests are executed against the full, integrated system stack, there are seemingly infinite possibilities where things can go wrong. So these kinds of tests can be tedious and unpredictable to write.

3. **can fail intermittently, seemingly non-deterministically** because three processes/threads are involved (test, browser, Rails server) and page loads/response times vary from test to test, timing issues can arise, which can cause unstable tests (the same test sometimes passes, sometimes fails). 

4. **can fail on minor HTML/CSS changes** feature specs use CSS selectors and messages to navigate/assert the HTML pages. When those are changed the tests fail, despite the feature still working.

5. **complex seed data setup** in order to do anything interesting in lale, you need at least a user, a circle, a working group and the correct roles to relate them to each other. This can be difficult to set up by hand for each test.

### Dealing with the pros and cons

### Assume that things won't always go smoothly

    "Unfortunately, the nature of full-stack testing is that things can and do go wrong from time to time."
    -- https://github.com/teampoltergeist/poltergeist#troubleshooting

* _sometimes_ things will not work as expected and you have no idea why. Debugging sessions can be huge time sinks with seemingly no progress. Accept and deal with it.

* Timebox a debugging session, and put an imperfect/partial/messy test in place if you can, rather than no test at all. 

* Stop debugging when you're exhausted/frustrated and get something else done. Retry with a fresh, calm mind on the next morning.

* Show/explain the test to another developer (or a [rubber duck](https://en.wikipedia.org/wiki/Rubber_duck_debugging)) and debug together. 
 
* Sometimes you'll have to disable a spec that fails intermittently until you get a change to debug it thoroughly. 

### Reduce test complexity, increase test robustness

* don't test more than one use case per file (for example: check the contents of a working group dashboard are correct separately from joining/leaving a group). Different use cases usually require different setup and steps, so the test file gets complex and hard to follow if several features are tested, which can cause bugs. 

* use expressive filenames related to the use case if possible. So rather than `show_working_group_spec.rb` use `show_working_group_dashboard_spec.rb` and `join_and_leave_working_group_spec.rb`.

* don't abstract and generalize test code/methods too agressively. It should always be easy to read and understand a test.

* don't make CSS selectors more specific than they need to; ideally you're using components selectors which are indepentent of the surrounding page.

* minimize technical complexity of the system under test to minimize runtime and the number of things that can go wrong. in particular:
* stub nonessential systems that you can test individually in separate integration tests (Email, external APIs, ...)

* use page objects to abstract the parts of the HTML page you are interested in in one object, and maintain the the CSS selectors for one page in one place. The page object is also a perfect place for helper code that simplifies testing. Our page objects are based on the excellent [site_prism gem](https://github.com/natritmeyer/site_prism).

* don't assert every detail of a page, assert what's essential. The more assertions, the more likely some of that will change in the future, requiring the test to be adapted.

* use rspec's `describe` blocks to describe the variation of the feature you're testing and `context` blocks for the preconditions of that particular test. Context-blocks usually begin with "when ...". A context-block will usually only have one `it` block, which describe the expected outcome. This structure may seem verbose, but it serves as excellent structure for finding out which tests to write, where to put which test, and document the feature well.

Example:

    describe "Join and leave a working group", js: true do
      describe "joining a group" do
        context "when use has not joined yet" do
          it "becomes member of the group" do
          end
        end
      end
    end


### Developing and debugging efficiently

#### General development tips

* testing selectors: use jQuery in the browser console to test the CSS selectors you want to use. It's much faster that way than to execute the test every time until you got the selector right. (slight gotcha: in rare cases jQuery selectors may not work with Capybara, since they use different CSS engines ([Sizzle](https://sizzlejs.com/) vs. [Nokogiri](http://www.nokogiri.org/)).

* write and use [powerful, expressive, flexible factories](/lale-help/lale-help/blob/master/spec/factories/circles.rb) to easily set up the seed data required for the test. Expressive factories also help understanding the setup quickly.

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

* use an existing spec as a scaffold for your new test (copy & paste to new file, adapt) to speed up things. Factor out things when you notice frequent repetition, though.

#### Debugging

* if you suspect timing issues, insert a `sleep 2` before the command that fails. When you're sure that's the issue, convert it to a `wait_for` [command to be more robust](https://github.com/natritmeyer/site_prism#waiting-for-an-element-to-exist-on-a-page) which waits for the required element to show up on the page.

* look at the screenshots in `tmp/capybara` that are created automatically at every test failure (we use the capybara-screenshot gem for that). Create a screenshot manually with `show!` or `save_and_open_page` to inspect an image/the HTML of the page at any time step.

* write [tests for non-trivial factories](/lale-help/lale-help/blob/master/spec/factory_specs/circles_factory_spec.rb) (sic!!!). Wrong seed data is a frequent source of errors in specs, you can rule them out completely this way. Learn about the more advanced features of factory_girl [here](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md). 

* (temporarily) assert expectations you have about the system in the test, if things are going wrong, like `expect(working_group.organizer).to eq(my_user)`. Often system setup issues cause errors. You can mitigate these with reliable factories and tests for them (see above).

* look at the Rails application log to understand what's going on, insert normal debug messages in your code.

* use `evaluate_script('some js code')` to evaluate javascript in the context of the current HTML page, sometimes very useful for inspection. 

* use [poltergeist's remote debugging feature](https://github.com/teampoltergeist/poltergeist#remote-debugging-experimental) to open the page you're testing in a DOM inspector.

* use `Capybara.pry` to start a shell / debugger in the context of the page. From there, use standard capybara API to inspect the page (like `find('some-css-selector')`)

* [5 more hints here](https://quickleft.com/blog/five-capybara-hacks-to-make-your-testing-experience-less-painful/). Also useful: [how to pause Capybara tests for DOM inspection](http://ricostacruz.com/til/pausing-capybara-selenium.html)

### Running tests faster

* use the [spring](https://github.com/rails/spring) Rails application preloader to shave 5-10 seconds off the test runtime. It's set up already, just use the wrapper scripts in the `bin` directory, like `bin/rake spec:features`. Be aware changes to Rails configuration and similar may need a restart to take effect.

* use the [poltergeist](https://github.com/teampoltergeist/poltergeist) test driver as default, it uses a headless Webkit browser engine (PhantomJS) and is significantly faster than Selenium. lale is set up that way already. Switch to back to Selenium if you want to follow the test steps in the browser. Use `SELENIUM=1` on the command line to use it.

* use the [backdoor](/lale-help/lale-help/blob/master/spec/support/backdoor.rb), rather than logging in a user through the sign in form for every test. Make sure to have separate sign-in specs, though!

* start the test on the page you want to test rather than navigating there from another page. Write separate, simple tests to navigating to the feature, once, if you care about it.

* test only the happy path (==success) and maybe one variation (error) in a feature spec. Use simpler, faster tests (model/controller/interaction) to test the other variations of a feature.

* contrary to best practise for unit tests, run **multiple** assertions per test. test everything that can be tested for the data setup you just tediously built.

* run only one test or subsets of them with: `bin/rake SPEC=path/to/spec/file/or/directory`

* parallelize tests, i.e. run subsets of tests in separate processes in parallel. This puts a lot of load on the test machine though and may produce more timing issues (leading to intermittent test failures) on insufficient hardware.

## Further documentation

... can be found on [the wiki](https://github.com/lale-help/lale-help/wiki)

## License

This project uses the [MIT License](https://github.com/lale-help/lale-help/blob/master/LICENSE).
