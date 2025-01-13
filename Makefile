env-setup:  ## Creates a new virtual environment
	pyenv local 3.12.2 ; \
	pyenv install 3.12.2 --skip-existing ; \
	pyenv exec pip install pipenv ; \
	pipenv --rm ; \
	pipenv --python 3.12.2 ; \
	pipenv run python --version ;\
	pipenv install --dev

.SILENT:
.PHONY: env-setup
