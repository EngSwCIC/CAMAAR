FROM ruby:2.7.5
WORKDIR /camaar
COPY ./ /camaar/

RUN bundle install
RUN echo JWT_SECRET_KEY: $(rake secret) >> application.yml
RUN rails db:migrate

CMD ["rails", "server", "-p", "3030", "-b", "0.0.0.0"]
