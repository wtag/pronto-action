FROM ruby:2.6-alpine

RUN apk --no-cache add jq curl make cmake g++ openssl-dev git

RUN gem install --no-document \
  pronto \
  pronto-rubocop \
  pronto-flay \
  pronto-brakeman \
  pronto-rails_best_practices \
  pronto-rails_schema \
  pronto-reek \
  pronto-scss

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
