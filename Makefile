ifndef VERSION
$(error VERSION is not set)
endif

NAME="kierans777/flyway-mysql-rds"

all: build

build:
	docker build -t $(NAME):$(VERSION) .

push:
	docker push $(NAME):$(VERSION)
