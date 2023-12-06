FROM ruby:2.6-alpine

RUN apk --no-cache add jq curl git
RUN gem install bundler

COPY Gemfile* ./

RUN apk --no-cache add --virtual build-deps make cmake g++ openssl-dev && \
  bundle install -j $(nproc) && \
  apk del build-deps

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
