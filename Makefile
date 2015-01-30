.PHONY: images

images: database.image insecure.image secure.image

database.image : NAME = conjurdemos/docker-secrets-2-db

insecure.image : NAME = conjurdemos/docker-secrets-2-insecure

secure.image : NAME = conjurdemos/docker-secrets-2-secure

%.image: %/Dockerfile %/*
	docker build -t $(NAME) $*
	docker push $(NAME)
	docker inspect -f '{{.Id}}' $(NAME) > $@
