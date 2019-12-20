FROM ruby:2.6-alpine

RUN apk add jq curl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
