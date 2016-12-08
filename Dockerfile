FROM ruby:2.2.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /jail_dashboard

# Install phantomJS from the `dependencies/` directory
ADD dependencies /dependencies
WORKDIR /dependencies
RUN tar -xf phantomjs-*.tar.bz2 &&\
    mv phantomjs-*/bin/phantomjs /bin/ &&\
    rm -r phantom*

RUN apt-get install -y \
  build-essential \
  chrpath \
  libssl-dev \
  libxft-dev \
  libfreetype6 \
  libfreetype6-dev \
  libfontconfig1 \
  libfontconfig1-dev

WORKDIR /jail_dashboard

ADD Gemfile /jail_dashboard/Gemfile
ADD Gemfile.lock /jail_dashboard/Gemfile.lock
RUN bundle install

ENTRYPOINT bundle exec rails s -b '0.0.0.0' -p 3000
