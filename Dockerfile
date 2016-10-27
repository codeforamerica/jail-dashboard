FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /jail_dashboard
WORKDIR /jail_dashboard
ADD Gemfile /jail_dashboard/Gemfile
ADD Gemfile.lock /jail_dashboard/Gemfile.lock
RUN bundle install
ADD . /jail_dashboard