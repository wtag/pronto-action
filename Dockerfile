FROM ruby:3.2-alpine

# Runtime dependencies
RUN apk --no-cache add \
  jq \
  curl \
  git \
  libffi

RUN gem install bundler

COPY Gemfile* ./

# Build dependencies for native gems (ffi + rugged)
RUN apk --no-cache add --virtual build-deps \
    build-base \
    linux-headers \
    libffi-dev \
    openssl-dev \
    cmake \
  && bundle install -j $(nproc) \
  && apk del build-deps

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
