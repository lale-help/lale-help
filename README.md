# Lale.Help

[![Circle CI](https://circleci.com/gh/lale-help/lale-help.svg?style=svg)](https://circleci.com/gh/lale-help/lale-help)

This is the rails application used for lale.help.

## Development

You can run Lale on your development machine using one of two methods:
  1) as a standard Rails project
  2) using [Docker](https://www.docker.com/) *(recommended for Rails beginners)*

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

* using the i18n framework means all **strings and translations** should be stored in locale files stored in `config/locales`. The same goes for **date**, **time** and **number formats**. 

* be aware not to build one sentence from several smaller translations, because that hard-codes a certain sentence structure, which may not be the same in every language. Always translate complete sentences, or at least ensure that words of a sentence can be in arbitrary order.

* don't pluralize words in Ruby code, as pluralization rules can be different. Slavic languages have two plural forms, for example: the word "apples" will be differnt in "two apples" and "five apples". Rails i18n can handle that with it's built in [i18n rules](https://goo.gl/BGY6KC) if you take advantace of the feature (pass `count: number` to `I18n.t`).

## Restoring the database from snapshot

``` sh
# in one terminal tab
docker-compose up

# in another terminal tab
cp /path/to/database/snapshot/SNAPSHOT_NAME .
./docker/restore-db-from SNAPSHOT_NAME
```

## Writing feature specs

"Feature specs" is the most common name in Rails project for a type of system integration and acceptance test that is executed through a standard web browser. They live in the `spec/features` directory.

### Pros and cons of feature specs

I'm summarizing these here because they help to understand some decisions I took for lale's feature feature specs setup.

#### Pros

1. **completely decoupled** from the actual Ruby system (since they use the browser/HTML page as the interface to the application). This allows refactoring it without any changes in the spec. 

2. they are **very high-level** and written with the RSpec BDD framework, so they document quite well, and in nontechnical language what lale is expected to do.

3. **high confidence** since they test the whole system and behave very similar to a real user of the system, if the test passes there it is very probable that the feature under test actually works as expected.

#### Cons:

1. **very slow**: feature specs usually take 1-2 orders of magnitude longer to run than a unit test. Thus test feedback is much slower. Test suite runtimes can easily exceed the patience of the average programmer, which leads to neglection of this kind of tests.

2. **huge system under test**: since these tests are executed against the full, integrated system, there are seemingly infinite possibilities of things going wrong. So these kinds of tests can be tedious, slow and unpredictable to write.

3. **can fail intermittently** because at least two processes are involved (test process, browser process, Rails server process or thread) timing issues often arise, which can sometimes cause test failures. 

4. **can fail on minor HTML/CSS changes** feature specs expect certain CSS selectors and messages in the HTML pages, when they change the tests fail, despite the feature still working.

5. **complex seed data setup** in order to do anything interesting in lale, you need at least a user, a circle, a working group and the correct roles to relate them to each other. This can be difficult to set up by hand for each test.

### Dealing with the pros and cons

### Be humble and calm, assume there will be problems

    "Unfortunately, the nature of full-stack testing is that things 
    can and do go wrong from time to time."
    -- https://github.com/teampoltergeist/poltergeist#troubleshooting

* sometimes things will not work as expected and you have no idea why. Debugging sessions can be huge time sinks with seemingly no progress being made. Accept and deal with it.

* Timebox the debugging and try to put a messy test in place if you can, rather than not having a test at all. 

* Stop debugging and start with a fresh, calm mind on the next morning. 

* Show the test to another developer and debug together. 
 
* Sometimes you'll have to stop when 80% of a feature is tested
 
* Sometimes you'll have to disable a spec that fails intermittently until you get a change to debug it thoroughly. 

### Test understandability

* don't test more than one feature per file. use a expressive filename if possible, rather than "create_xy_spec.rb".

* don't refactor / abstract test code to agressively. It should always be easy to read and understand a test.

### Test robustness

* minimize technical complexity of the system under test to minimize runtime and the number of things that can go wrong. in particular:
* stub systems that you can test individually in separate integration tests (Email, search, external APIs, ...)

* don't make CSS selectors more specific than they need to; ideally you're using components selectors which are indepentent of the surrounding page.

### Development & debugging tools

* use jQuery in the browser console to test the CSS selectors you want to use in the test. It's much faster that way than to execute the test every time you change a selector.

* look at the screenshots in `tmp/capybara` that are created at every test failure. Create a screenshot manually with `show!` to inspect the page at a certain step.

* write and use [powerful, expressive, flexible factories](/lale-help/lale-help/blob/master/spec/factories/circles.rb) to help you and other developers easily set up the seed data you need for the test, and quickly understand the system state before the test.

* write [tests for non-trivial factories](/lale-help/lale-help/blob/master/spec/factory_specs/circles_factory_spec.rb) (sic!). This will give you the confidence that your system is set up as you expect it, when the system doesn't behave as you expect it, ruling out a frequent source of errors.

* explicitly assert expectations you have about the system, like `expect(working_group.organizer).to eq(my_user)`. Often system setup issues cause errors. You can mitigate these with reliable factories and tests for them (see above).

* use the [spring](https://github.com/rails/spring) Rails application preloader to shave 5-10 seconds off the test runtime. It's set up already, just use the wrapper scripts in the `bin` directory, like `bin/rake spec:features`.

* use the poltergeist (PhantomJS) test driver rather than Selenium as default, it is significantly faster. 

* switch to Selenium if you want to follow along what the test does in the browser.

### Test speed

* use the backdoor (`... as: admin`) to log in the user you want to, rather than going through the sign in form for every test (make sure to have sign-in specs, though!)

* access the page under test directly rather than navigating there from the circle dashboard / some other page

* test only the happy path (==success) and maybe one variation (error) in a feature spec. Use simpler, faster tests (model/controller/interaction) to test more variations of a feature.

* contrary to best practise for unit tests, do **multiple** assertions per test. test everything that can be tested for the data setup you just tediously built.

* run only one test or subsets of them with: `bin/rake SPEC=spec/features/circle`

## License

This project uses the [MIT License](https://github.com/lale-help/lale-help/blob/master/LICENSE).
