FROM ruby:3.2-alpine

RUN apk --no-cache add jq curl git
RUN gem install bundler

RUN git config --global --add safe.directory /github/workspace

COPY Gemfile* ./

RUN apk --no-cache add --virtual build-deps make cmake g++ openssl-dev && \
  bundle install -j $(nproc) && \
  apk del build-deps

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
