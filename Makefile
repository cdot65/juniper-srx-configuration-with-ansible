SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help
.PHONY: help apply bootstrap config container push shell

DOCKER_IMG = registry.gitlab.com/cremsburg/juniper-automation-container
DOCKER_TAG = 0.0.1

help:
	@echo ''
	@echo 'Makefile will help us build with the following commands'
	@echo '		make apply				applies the last created configuration'
	@echo '		make bootstrap				returns devices to a bare minimum configuration'
	@echo '		make config				builds the device configuration, does not apply'
	@echo '		make container				builds the docker container'
	@echo '		make push				builds the configuration and pushes it to the devices'
	@echo '		make shell				runs the container and gives you access to its shell'

push: config apply

apply:
	docker run -it \
	--rm \
	-v $(PWD)/files/:/home/tmp/files \
	-v $(PWD)/files/tmp:/tmp \
	-w /home/tmp/files/ansible/ \
	$(DOCKER_IMG):$(DOCKER_TAG) ansible-playbook pb.configuration.apply.yaml

bootstrap:
	docker run -it \
	--rm \
	-v $(PWD)/files/:/home/tmp/files \
	-v $(PWD)/files/tmp:/tmp \
	-w /home/tmp/files/ansible/ \
	$(DOCKER_IMG):$(DOCKER_TAG) ansible-playbook pb.configuration.bootstrap.yaml 

config:
	docker run -it \
	--rm \
	-v $(PWD)/files/:/home/tmp/files \
	-v $(PWD)/files/tmp:/tmp \
	-w /home/tmp/files/ansible/ \
	$(DOCKER_IMG):$(DOCKER_TAG) ansible-playbook pb.configuration.build.yaml

container:
	docker build -t $(DOCKER_IMG):$(DOCKER_TAG) files/docker/ansible/

shell:
	docker run -it \
	--rm \
	-v $(PWD)/files/:/home/tmp/files \
	-v $(PWD)/files/tmp:/tmp \
	-w /home/tmp/files/ansible/ \
	$(DOCKER_IMG):$(DOCKER_TAG) /bin/sh
