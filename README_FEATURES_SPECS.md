## Intro notes

- the feature specs are in spec/features
- FactoryGirl factories are in spec/factories

## overview of the machinery involved in feature specs

### rspec 

(BDD framework) for structuring tests, assertions, etc.
  it's the most common Ruby testing framework, useful for all kinds of tests (from unit to integration)
  http://www.relishapp.com/rspec/

### Capybara

is a DSL and abstraction layer for writing browser-based tests
http://jnicklas.github.io/capybara/ 
In our case we have configured it to execute with the Selenium driver.

### FactoryGirl

lets you define factories for test data
http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md

All of there are standard Rails gems (libraries) and can be found on GitHub.

## Example feature spec (uploading a file)

https://goo.gl/7xVCwL

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

- all translations are in files in the config/locales subdirectory.
- we use Rails' default mechanism, documented here: http://guides.rubyonrails.org/i18n.html


## General structure of a feature spec

1) set up a known state application (create data in DB, navigate to page)
2) execute the feature that you want to test
3) verify expected behaviour


## Q: is any state kept between tests? 

No. Database content, cookies, last visited page, are all reset between tests


## Some Capybara debugging helpers

- show! 
short form for save_and_open_screenshot => opens a PNG screenshot

- there's also save_and_open_page => opens the HTML page


## some pointers on Sublime Text configuration

- YAML Nav - YAML navigation package for sublime text
  https://packagecontrol.io/packages/YAML%20Nav
- GitGutter - shows git changes in the gutter
  https://packagecontrol.io/packages/GitGutter
- many more here (in Installed Packages)
  https://github.com/phillipoertel/st3_config
  (I don't know an easy way to install them directly, use packagecontrol.io)
- packagecontrol.io: searchable Sublime Text package repository 
