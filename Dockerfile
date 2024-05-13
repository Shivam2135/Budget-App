#FROM ruby:latest
#WORKDIR /app
#RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
#RUN gem install rails
#COPY Gemfile Gemfile.lock ./
#RUN bundle install
#COPY . .
#RUN rails db:create db:migrate
#EXPOSE 3000
#CMD ["rails", "server", "-b", "0.0.0.0"]

# Dockerfile development version
FROM ruby:3.1.2 AS drkiq-development

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# Default directory
ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

# Install gems
WORKDIR $INSTALL_PATH
COPY drkiq/ .
RUN rm -rf node_modules vendor
RUN gem install rails bundler
RUN bundle install
RUN yarn install

# Start server
CMD bundle exec unicorn -c config/unicorn.rb

