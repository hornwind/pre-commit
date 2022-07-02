#!/usr/bin/env bash

set -e
set -u
set -o pipefail


export PATH=$PATH:/usr/local/bin


needy_tools=(
  "ct"
  "helm"
  "yamale"
  "yamllint"
  )

assert_tools() {
    local tool="$1"

    command -v "$tool" >/dev/null 2>&1 || {
        echo "ERROR: ${tool} is not installed." >&2
        exit 1
        }
}

for tool in "${needy_tools[@]}"; do
    assert_tools "$tool"
done

if [[ -f ct.yaml || -f $HOME/.ct || -f /etc/ct ]]; then
    ct lint
else
    echo "Fail: need to create ct config"
    echo ""
    echo "Chart-test documentation here:"
    echo "https://github.com/helm/chart-testing/blob/main/README.md"
fi
