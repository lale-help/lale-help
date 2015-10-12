# Lale.Help

[![Build Status](https://travis-ci.org/lale-help/lale-help.svg?branch=master)](https://travis-ci.org/lale-help/lale-help)

This is the rails application used for lale.help.

## System Setup

To setup your system on OS X, just run:

    ./bin/setup-osx.sh

## Starting Rails

    bin/foreman start

## Running Tests

    bin/rspec

## URLs

production: [lale.help](https://lale.help)

staging: [staging.lale.help](https://staging.lale.help)

## Conventions

- We *must* be able to work with any language, so absolutely no text should be hard coded into the application. All text *must* be
referenced from I18n configuration files.



## Internationalization (I18N)

To ensure that Lale can be accessible to anybody regardless of language, we are using Rails' built in
internationalization framework. Please review the [documentation](http://guides.rubyonrails.org/i18n.html) for I18n
when working on Lale.

All strings and translastions used in the application should be stored in locale files stored in `config/locales` and should
try to use I18n's lazy loading for translation keys in templates/partials.



