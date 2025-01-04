
# _conda-setup:
# 	conda --version
# 	conda init zsh

# env-setup: _conda-setup  ## Creates a new local conda environment
# 	conda create --prefix ./env python=3.12 jupyter -y; \
# 	conda install matplotlib -y ; \
# 	conda install pandas -y ; \
# 	conda install numpy -y ; \
# 	conda install scikit-learn -y
# 	conda env export --prefix ./env --file environment.yaml

# env-recreate: _conda-setup ## Use this to recreate from YAML file
# 	conda env create --prefix ./env --file environment.yaml

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
