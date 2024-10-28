
_conda-setup:
	conda --version
	conda init zsh

env-setup: _conda-setup  ## Creates a new local conda environment
	conda create --prefix ./env python=3.12 jupyter -y; \
	conda install matplotlib -y ; \
	conda install pandas -y ; \
	conda install numpy -y ; \
	conda install scikit-learn -y
	conda env export --prefix ./env --file environment.yml

env-recreate: _conda-setup ## Use this to recreate from YAML file
	conda env create --prefix ./env --file environment.yml

.SILENT:
.PHONY: env-setup env-recreate 
