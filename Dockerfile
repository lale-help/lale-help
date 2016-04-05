FROM ruby:2.2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD . /myapp
RUN bundle install --jobs 4
RUN echo foo