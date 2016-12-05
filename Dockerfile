FROM ruby:2.2.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /jail_dashboard

WORKDIR /jail_dashboard

# Install PhantomJS
ENV PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"

RUN apt-get install -y \
  build-essential \
  chrpath \
  libssl-dev \
  libxft-dev \
  libfreetype6 \
  libfreetype6-dev \
  libfontconfig1 \
  libfontconfig1-dev

RUN mkdir /phantom &&\
  cd /phantom &&\
  wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 &&\
  tar xvjf $PHANTOM_JS.tar.bz2 &&\
  mv $PHANTOM_JS /usr/local/share &&\
  ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

ADD Gemfile /jail_dashboard/Gemfile
ADD Gemfile.lock /jail_dashboard/Gemfile.lock
RUN bundle install
