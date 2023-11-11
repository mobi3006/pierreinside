# Git Lifecycle Hooks

For too long time I've ignored this powerful tool that I use for

* local pre-commit formatting and checks

---

## Pre-Commit Hooks

* [official documentation](https://pre-commit.com/)

### Setup

* adding `.pre-commit-config.yaml`](.pre-commit-config.yaml)
* `cd learnit`
* `pre-commit install`

You will find the hook configured in `.git/hooks`.

### Manual Usage

`pre-commit run --all-files`

### Auto Usage

Every `git commit` will FIRST check and change all files (depending on which hooks are enabled). If there is no changed file it will report that it was running like that:

![pre-commit-hook-nochange.png](docs/images/pre-commit-hook-nochange.png)

### Update

`pre-commit autoupdate` will change the `.pre-commit-config.yaml`

---

## Implement your own hook

For THIS repo I do not want to reference anything related to my current company. Therefore I would like to grep all files for some substrings.

The folder `.git/hooks` of every git repo contains some sample 

* `pre-commit.sample`
* `pre-push.sample`
* `prepare-commit-msg.sample`
