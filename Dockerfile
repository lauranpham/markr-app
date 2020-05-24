FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /stile-markr
WORKDIR /stile-markr
COPY Gemfile /stile-markr/Gemfile
# COPY Gemfile.lock /stile-markr/Gemfile.lock
RUN bundle install
COPY . /stile-markr

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]