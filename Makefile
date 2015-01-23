.PHONY: all database insecure conjurenv

all: database insecure conjurenv

database:
	docker build -t conjur-redmine-db database

insecure:
	docker build -t conjur-redmine-insecure insecure

conjurenv:
	docker build -t conjur-redmine-conjurenv conjurenv
