FROM uggedal/alpine-3.0
MAINTAINER Conjur Inc

RUN apk update && \
  apk add mysql mysql-client bash

ADD sys_maint.cnf /etc/mysql/sys_maint.cnf
ADD my.cnf /etc/mysql/my.cnf
ADD start /start
RUN chmod 755 /start

EXPOSE 3306

VOLUME ["/var/lib/mysql"]
VOLUME ["/run/mysqld"]

ENV DB_NAME redmine_production
ENV DB_USER redmine
ENV DB_PASS ZemuBRAXu2tadr

CMD ["/start"]
