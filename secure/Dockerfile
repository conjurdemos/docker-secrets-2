FROM sameersbn/redmine:2.6.1

RUN wget -q https://s3.amazonaws.com/conjur-releases/omnibus/conjur_4.18.6-1_amd64.deb -O /tmp/conjur.deb && dpkg -i /tmp/conjur.deb && rm /tmp/conjur.deb

ADD app.secrets /app.secrets
ADD start /start
RUN chmod a+x /start

ENV DB_TYPE mysql
ENV DB_PORT 3306
ENV DB_NAME redmine_production
ENV DB_USER redmine

ENTRYPOINT [ "/start" ]
