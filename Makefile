
_conda-setup:
	conda --version
	conda init zsh

env-setup: _conda-setup  ## Creates a new local conda environment
	conda create --prefix ./env python=3.12 jupyter -y
	conda env export --prefix ./env --file environment.yml

env-recreate: _conda-setup ## Use this to recreate from YAML file
	conda env create --prefix ./env --file environment.yml

launch: ## Launch jupyter notebook

.SILENT:
.PHONY: env-setup env-recreate 
