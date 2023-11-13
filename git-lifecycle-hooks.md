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

> THIS is about the [open-source project](https://pre-commit.com/) that provides some tooling around the pre-commit hook

* [official documentation](https://pre-commit.com/)

In the end it is using the normal git hooks approach (`.git/hooks/pre-commit`). It only comes with some typical pre-commit checks ([check this list](https://pre-commit.com/hooks.html)) and a language (`.pre-commit-config.yaml`) for its configuration.

If a project has such a `.pre-commit-config.yaml` file you can install all configured hooks by `pre-commit install`.

### Setup

* adding `.pre-commit-config.yaml`](.pre-commit-config.yaml)
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
