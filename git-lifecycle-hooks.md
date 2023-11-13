# Git Lifecycle Hooks

For too long time I've ignored this powerful tool that I use for

* local pre-commit formatting and checks
* add branch name to a commit message

---

## Implement your own hook

The folder `.git/hooks` of every git repo contains some sample 

* `pre-commit.sample`
* `pre-push.sample`
* `prepare-commit-msg.sample`

A hook implementation has to have a specific name (e. g. `pre-commit`) and needs to be executable. You can either/or

* create it manually
* create a `~/.git-templates/hooks` folder containing all hooks that should be copied during `git init`
  * `git init` is not only used for the initial git-repo setup but you can use it anytime when you want to have the `~/.git-templates` applied

For the pre-commit hook there was a framework (Plugin-based) implemented that gets contributions for a wide range of technologies and use-cases (see below).

---

## Pre-Commit Hook Project

> THIS is about the [pre-commit open-source project](https://pre-commit.com/) that provides some tooling around the pre-commit hook

* [official documentation](https://pre-commit.com/)

One drawback of the core git lifecycle hooks is that there is only a single file per lifecycle trigger to be used, e. g. ALL `pre-commit` actions have to be implemeted in `.git/hooks/pre-commit`. The [pre-commit open-source project](https://pre-commit.com/) offers a plugin approach based on a (`.pre-commit-config.yaml`) that can reference different sources

```
repos:
- repo: https://github.com/antonbabenko/pre-commit-terraform
  rev: v1.83.5
  hooks:
    - id: terraform_fmt
- repo: https://github.com/mattlqx/pre-commit-search-and-replace
  rev: v1.0.5
  hooks:
  - id: search-and-replace
```

The core pre-commit git hook (residing in `.git/hooks/pre-commit`) is installed via `pre-commit install`. Its implementation is based on the configuration in `.pre-commit-config.yaml`. Each plugin is using a specific configuration file (e. g. `.pre-commit-search-and-replace.yaml` for https://github.com/mattlqx/pre-commit-search-and-replace). You can reuse this code within [GitHub workflows via `pre-commit` GitHub Action](https://github.com/pre-commit/action).

There are quite a lot of ([plugins](https://pre-commit.com/hooks.html)) available.

Here's an example how it could look like:

* https://github.com/mattlqx/pre-commit-search-and-replace/blob/main/.pre-commit-config.yaml

### Install

```
pip install pre-commit
```

### Setup

* adding `.pre-commit-config.yaml`](.pre-commit-config.yaml) to the root of your repo
* `cd my-git-repo`
* `pre-commit install`
  * this adds `.git/hooks/pre-commit` implementation based on `.pre-commit-config.yaml` into the repository

### Manual Usage

`pre-commit run --all-files`

### Auto Usage

Every `git commit` will FIRST check and change all files (depending on which hooks are enabled). If there is no changed file it will report that it was running like that:

![pre-commit-hook-nochange.png](docs/images/pre-commit-hook-nochange.png)

### Update

`pre-commit autoupdate` will change the `.pre-commit-config.yaml`
