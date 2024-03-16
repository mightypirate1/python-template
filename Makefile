.PHONY: clean clean-venv clean-pyc clean-test-repo create-repo install lint reformat venv test

clean: clean-pyc clean-venv clean-test-repo

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
	find . -name '.ruff_cache' -exec rm -fr {} +

clean-venv: ## remove venv
	rm -rf .venv

clean-test-repo:
	rm -rf .test_repo

install: venv
	bash -c "\
	source .venv/bin/activate && \
	pip install cookiecutter \
    "

venv: clean
	python3 -m venv .venv --prompt cookiecutter

create-repo:
	cookiecutter .

test:
	bash tests/template_test.sh repo-test

