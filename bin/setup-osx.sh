#!/bin/bash -e

echo "== Updating Homebrew =="
brew update


echo "== Installing PostgreSQL =="
brew install postgresql
brew upgrade postgresql || true


echo "== Installing ruby =="
brew install rbenv
brew upgrade rbenv || true
brew install ruby-build
brew upgrade ruby-build || true
rbenv install -s 2.2.3

if [ -z "$RBENV_SHELL" ]; then
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  eval "$(rbenv init -)"
fi


echo "== Installing Bundler =="
gem install bundler
rbenv rehash


echo "== Installing Gems =="
bundle install -j8 --path .bundle


echo "== Setup DB =="
bin/rake db:init
bin/rake postgresql:start &
bin/rake db:create db:migrate

PG_PID=$(cat .postgres/postmaster.pid | head -n 1)
kill $PG_PID
wait $PG_PID


echo "== Finished! =="
