FROM instructure/ruby-passenger:2.5

USER root
RUN apt-get update && \
  apt-get install -qq -y --no-install-recommends postgresql-client && \
  rm -rf /var/lib/apt/lists/*
USER docker

ENV LANG C.UTF-8
ENV RAILS_ENV production

ADD Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

USER root
RUN chown -R docker:docker .
USER docker

RUN RAILS_ENV=production rails assets:precompile
