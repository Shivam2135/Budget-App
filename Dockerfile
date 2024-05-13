FROM ruby:latest
WORKDIR /app
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN gem install rails
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN rails db:create db:migrate
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

