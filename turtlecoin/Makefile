-include env_make

# docker build \
# -t soregums/turtlecoin:turtlecoind-v0.14.0-RC1 \
# --build-arg GIT_REPO=turtlecoin \
# --build-arg GIT_BRANCH=v0.14.0-RC1 \
# .

REPO = soregums/turtlecoin
NAME = ruby-$(RUBY_VER_MINOR)

WODBY_USER_ID ?= 1000
WODBY_GROUP_ID ?= 1000

BASE_IMAGE_TAG = $(RUBY_VER)

ifeq ($(TAG),)
    TAG ?= 
endif

ifneq ($(RUBY_DEV),)
    NAME := $(NAME)-dev
endif

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build test push shell run start stop logs clean release

default: build

build:
  docker build \
    -t soregums/turtlecoin:turtlecoind-dev \
    .

test:
  echo "no tests"

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push
