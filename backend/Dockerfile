FROM ruby:3.2.2

WORKDIR /backend

RUN apt-get update -qq && apt-get install -y \
    nodejs

COPY Gemfile* ./

RUN gem install bundler && bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
