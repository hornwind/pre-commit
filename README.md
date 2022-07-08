# Pre-commit hooks

This repo defines Git pre-commit hooks intended for use with [pre-commit](https://pre-commit.com/). More hooks available [here](https://github.com/gruntwork-io/pre-commit).

* **ct-lint**: Automatically run `ct lint` on your Helm charts in `charts` directory of your repo. [Chart-testing documentation](https://github.com/helm/chart-testing/blob/main/README.md).
* **helm-kubeval**: Run [kubeval](https://www.kubeval.com/) over `helm template` of you chart in `charts` directory of your repo.


# General Usage

In each of your repos, add a file called `.pre-commit-config.yaml` with the following contents:
```yaml
repos:
  - repo: https://github.com/hornwind/pre-commit
    rev: v0.2.0
    hooks:
      - id: ct-lint
      - id: helm-kubeval
        args: ["--kubernetes-version 1.19.0"]
```

Next, have every developer:
1. Install [pre-commit](https://pre-commit.com/#install). E.g. `pip install pre-commit`.
2. Run `pre-commit install` in the repo.
