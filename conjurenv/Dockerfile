FROM ruby:2.0

RUN curl -o /tmp/conjur.deb https://s3.amazonaws.com/conjur-releases/omnibus/conjur_4.18.0-1_amd64.deb && dpkg -i /tmp/conjur.deb

ADD app.secrets /app.secrets
ADD app.rb /app.rb

ENTRYPOINT [ "/opt/conjur/bin/conjur", "env", "run", "-c", "/app.secrets", "--", "ruby", "/app.rb" ]
