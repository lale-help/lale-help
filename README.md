# Lale.Help

[![Build Status](https://travis-ci.org/lale-help/lale-help.svg?branch=master)](https://travis-ci.org/lale-help/lale-help)

This is the rails application used for lale.help.

## System Setup
Install [Dcoker](http://www.docker.com/) for your OS.

## Development
  * open a docker terminal
  * take a note of the IP at the top right (Lets call it DockerIP)
  * go to lale-help

### Starting Rails
  * run `docker-compose up`
  * go to http://\<DockerIP\>:5000

### Running Tests
  * run `docker-compose run bin/rspec`

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
