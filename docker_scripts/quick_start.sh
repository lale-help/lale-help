#!/bin/bash -ex
bundle install --jobs 4
rake db:create
rake db:migrate

# since unicorn leaves behind pid files sometimes
rm -r tmp
rails s -p 3000 -b '0.0.0.0'
