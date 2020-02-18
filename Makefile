.ONESHELL:
SHELL := /bin/bash

deploy:
	bash scripts/deploy.sh $(NAMESPACE_NAME)

destroy:
	bash scripts/destroy.sh