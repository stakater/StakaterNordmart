.ONESHELL:
SHELL := /bin/bash

deploy:
	bash scripts/deploy.sh

destroy:
	bash scripts/destroy.sh