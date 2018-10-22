# Budgerigar Dockerfile
#
# We'll use this image for both dev and prod

FROM ruby:latest
MAINTAINER Andrew Ek <andrewek@gmail.com>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - libpq-dev: Use Postgres
#
# When installing, -qq suppresses prompts, and -y answers "yes" to prompts
RUN apt-get update && apt-get install -qq -y build-essential libpq-dev --fix-missing --no-install-recommends

# Install plugins for our static analysis tools
RUN apt-get install cmake -qq -y
RUN apt-get install pkg-config -qq -y

# Provide TLS 1.2 Support
RUN apt-get install --only-upgrade openssl -qq -y
RUN apt-get install --only-upgrade libssl-dev -qq -y

# We'll install this thing in /app
ENV INSTALL_PATH /budgerigar
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

RUN bundle install

# Run Puma, Run!
CMD bundle exec puma -C config/puma.rb
