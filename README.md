# Lale.Help

[![Build Status](https://travis-ci.org/lale-help/lale-help.svg?branch=master)](https://travis-ci.org/lale-help/lale-help)

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
| Script Description                         | How to run               |
|--------------------------------------------|--------------------------|
| Start Rails (and other services)           | `./docker/start`         |
| Open a Rails console                       | `./docker/rails-console` |
| Run Tests                                  | `./docker/rspec`         |
| Migrate the DB                             | `./docker/db-migrate`    |
| Run a one off command in the web container | `./docker/exec COMMAND`  |
| Run bash on the web container              | `./docker/shell`         |
| Inspect the DB with psql                   | `./docker/psql`          |
| View the logs from every service           | `./docker/logs`          |
| Stop all services                          | `./docker/stop`          |
| Rebuild the web container                  | `./docker/build`         |
| Reset your Docker environment              | `./docker/reset`         |

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
