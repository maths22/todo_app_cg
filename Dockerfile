FROM instructure/ruby-passenger:2.7

USER root
RUN apt-get update && \
  apt-get install -qq -y --no-install-recommends postgresql-client build-essential && \
  rm -rf /var/lib/apt/lists/*
USER docker

ENV LANG C.UTF-8
ENV RAILS_ENV production

ADD --chown=docker:docker Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=docker:docker . .

RUN RAILS_ENV=production rails assets:precompile
