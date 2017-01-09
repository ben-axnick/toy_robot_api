FROM ruby:2.2.5-alpine

RUN apk add --no-cache git g++ musl-dev make

WORKDIR /app
ADD Gemfile Gemfile.lock ./
RUN bundle install
ADD . .
CMD bundle exec rackup -o 0.0.0.0
