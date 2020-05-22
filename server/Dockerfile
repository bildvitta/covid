FROM ruby:2.6.5-alpine

ENV TZ=America/Sao_Paulo

RUN apk update && apk add --no-cache \
  postgresql-dev \
  mysql-dev \
  gcc \
  musl-dev \
  bash \
  tzdata \
  ruby-dev \
  ruby-nokogiri \
  git \
  # nodejs \
  # yarn \
  imagemagick \
  pngcrush \
  optipng \
  build-base \
  libxml2-dev \
  libxslt-dev; \
  cp /usr/share/zoneinfo/$TZ /etc/localtime; \
  echo $TZ > /etc/timezone;

RUN gem install bundler

RUN mkdir /app
WORKDIR /app
COPY . /app

RUN bundle check || bundle install --without production

RUN chmod +x /app/scripts/entrypoint.sh