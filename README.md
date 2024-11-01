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

- Run `which pipenv` and it should point to a path like this: **~/.pyenv/shims/pipenv** (might be different according to your machine).
- Run `make env-setup` to setup a new environment.
- Run `pipenv install --dev` to install all dependencies, including dev dependencies.

## Datasets

- [BIVTatt-Dataset](https://github.com/mnicolas94/BIVTatt-Dataset/tree/master)
- [MNIST](https://github.com/cvdfoundation/mnist)

## References

- [Titanic on Kaggle](https://www.kaggle.com/c/titanic/overview)
