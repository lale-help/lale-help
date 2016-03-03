# Lale.Help

[![Build Status](https://travis-ci.org/lale-help/lale-help.svg?branch=master)](https://travis-ci.org/lale-help/lale-help)

This is the rails application used for lale.help.

## System Setup
Install [Docker](http://www.docker.com/) for your OS.

## Development
  * open a docker terminal
  * take a note of the IP at the top right (Lets call it DockerIP)
  * go to lale-help

### Starting Rails
  * run `docker-compose up`
  * go to http://\<DockerIP\>:5000

### Running Tests
  * run `docker-compose run web bin/rspec`

### Known issues
  * If you are using Windows the Run tests command above does not work.

### FAQs
  * How do I run an rake/rails command?
    * run `docker-compose run web \< command \>`
  * Things were working yesterday but all of a sudden everything is broken. What do I do?
    * First try run `docker-compose build` and then `docker-compose up`
    * if that fails file a github issue
  * How do I look at email sent by the app?
    * go to http://\<DockerIP\>:5000/letter_opener

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

## Restoring Database from Snapshot

``` sh
# in one terminal tab
docker-compose up

# in another terminal tab
cp /path/to/database/snapshot/SNAPSHOT_NAME .
./docker/restore-db-from SNAPSHOT_NAME
```

## License
This project uses the [MIT License](https://github.com/lale-help/lale-help/blob/master/LICENSE).