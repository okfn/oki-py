.PHONY: all list version dependencies test lint release

PACKAGE := oki
VERSION := $(shell head -n 1 oki/VERSION)

all: test

# http://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: \
	'/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
	sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

version:
	@echo $(VERSION)

dependencies:
	pip install --upgrade tox pytest twine wheel

develop:
	pip install -e .
	make dependencies

test:
	py.test tests/* --cov $(PACKAGE) --cov-report term-missing

lint:
	pylint $(PACKAGE)

release:
	git tag $(VERSION)
	git push --tags
	python setup.py sdist bdist_wheel --universal && twine upload dist/*
