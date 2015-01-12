.PHONY: all insecure env conjurenv

all: insecure env conjurenv

insecure:
	docker build -t conjur-secrets-demo-insecure insecure

env:
	docker build -t conjur-secrets-demo-env env

conjurenv:
	docker build -t conjur-secrets-demo-conjurenv conjurenv
