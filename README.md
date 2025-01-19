![Generic badge](https://img.shields.io/badge/active-yes-green.svg) ![Generic badge](https://img.shields.io/badge/Python-3.12.2-blue.svg) ![Static Badge](https://img.shields.io/badge/made_with-Jupyter_Notebooks-orange)

# Tattoo Verification Project Sandbox

This is a sandbox for a tattoo verification project.

## Prerequisites

For Linux or MAC

- Install **pyenv** with homebrew `brew install pyenv`
- Install **pipenv** `pyenv exec pip install pipenv`
- Update shell configuration (.zshrc or .bashrc)

```bash
export PATH="$HOME/.pyenv/shims:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
```

- Reload shell configuration `source ~/.bashrc` or `source ~/.zshrc`

## Environment Setup

- Run `make env-setup` to setup a new environment.
- Run `pipenv install --dev` to install all dependencies, including dev dependencies (not needed if you run previous command).

## Datasets

- [BIVTatt-Dataset](https://github.com/mnicolas94/BIVTatt-Dataset/tree/master)
- [MNIST](https://github.com/cvdfoundation/mnist)
- [Titanic on Kaggle](https://www.kaggle.com/c/titanic/overview)

## References

- [pandas](https://pandas.pydata.org/docs/index.html#)
- [numpy](https://numpy.org/doc/stable/index.html#)
- [Scikit Learn](https://scikit-learn.org/stable/index.html#)
- [Matplotlib](https://matplotlib.org/)
