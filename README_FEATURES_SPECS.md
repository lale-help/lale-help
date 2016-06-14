## Intro notes

- the feature specs are in spec/features
- FactoryGirl factories are in spec/factories

## overview of the machinery involved in feature specs

### rspec 

BDD framework for structuring tests, assertions, etc.
  it's the most common Ruby testing framework, useful for all kinds of tests (from unit to integration)
  http://www.relishapp.com/rspec/

### Capybara

Is a DSL and abstraction layer for writing browser-based tests
http://jnicklas.github.io/capybara/ 
In our case we have configured it to execute with the Selenium driver.

### FactoryGirl

Lets you define factories for test data
http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md

All of these are standard Ruby/Rails gems (libraries) and can be found on GitHub.

## Example feature specs (uploading a file)

- uploading a file: https://goo.gl/7xVCwL. Has an example for filling forms.
- testing the top level add menu: https://goo.gl/Qx4vsZ. Example for test setup, finding and clicking DOM elements.

## Executing the tests

- run all feature specs with `rake spec:features`
- run a subset of test files with `rake spec:features SPEC={file_name_pattern}`. file_name_pattern can be:
  - a regular filename, example: `spec/features/files/circle_files_spec.rb`
  - a filename with line number (runs only the test that covers that line): `spec/features/files/circle_files_spec.rb:42`
  - a glob pattern: `spec/features/files/*`

## Using the rails console to test/debug factories (sometimes useful)

```
$ rails console
> require 'factory_girl'
> FactoryGirl.reload
> FactoryGirl.create(:circle)
=> #<Circle:0x007ffd23af3638
    id: 58,
    created_at: Mon, 13 Jun 2016 20:39:21 CEST +02:00,
    updated_at: Mon, 13 Jun 2016 20:39:21 CEST +02:00,
    name: "Circle 1",
    language: 0,
    address_id: 297,
    must_activate_users: false>
```


## Translations / i18n

- we use Rails' default mechanism, documented here: http://guides.rubyonrails.org/i18n.html
- a call to `t('some.translation.key')` returns a translated string.
- the tests run in the English locale (lale's default).
- all translations are in YAML files in the directory `config/locales` .

## General structure of a feature spec

1. set up a known state application (create data in DB, navigate to page)
1. execute the feature that you want to test
1. verify expected behaviour


## Q: is any state kept between tests? 

No. Database content, cookies, last visited page, are all reset between tests


## Some Capybara debugging helpers

- `#show!`, a short form for `#save_and_open_screenshot` opens a PNG screenshot at the current step of test execution.
- `#save_and_open_page` opens the HTML page


## Some useful Sublime Text packages

- YAML Nav - YAML navigation package for sublime text
  https://packagecontrol.io/packages/YAML%20Nav
- GitGutter - shows git changes in the gutter
  https://packagecontrol.io/packages/GitGutter
- many more here (in Installed Packages)
  https://github.com/phillipoertel/st3_config
  (I don't know an easy way to install them directly, use packagecontrol.io)
- packagecontrol.io: searchable Sublime Text package repository 
