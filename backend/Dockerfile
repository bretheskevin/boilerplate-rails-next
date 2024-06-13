FROM ruby:3.3.3-alpine

RUN apk update && \
    apk add --no-cache \
        build-base \
        libc-dev \
        nodejs \
        postgresql-dev \
        postgresql-libs \
        tzdata

RUN bundle config --global frozen 1

WORKDIR /backend

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
