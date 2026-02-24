FROM ruby:3.4.8-alpine

RUN apk --no-cache add jq curl git
RUN gem install bundler

COPY Gemfile* ./

RUN apk add --no-cache --virtual build-deps \
      build-base \
      cmake \
      libffi-dev \
      openssl-dev \
      yaml-dev \
  && gem install bundler \
  && bundle config set force_ruby_platform true \
  && bundle install -j $(nproc) \
  && apk del build-deps


COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
