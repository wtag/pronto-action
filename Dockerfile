FROM ruby:3.2-alpine

# Runtime deps
RUN apk --no-cache add \
  jq \
  curl \
  git \
  libffi

RUN gem install bundler

COPY Gemfile* ./

# Build deps
RUN apk --no-cache add --virtual build-deps \
    build-base \
    linux-headers \
    libffi-dev \
    openssl-dev \
  && bundle install -j $(nproc) \
  && apk del build-deps

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
