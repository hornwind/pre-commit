#!/usr/bin/env bash

set -euo pipefail

export PATH=$PATH:/usr/local/bin


needy_tools=(
  "kubeval"
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

# get all changes in charts
check_changes() {
  local remote=${1}
  git --no-pager diff --find-renames --name-only "$(git rev-parse --abbrev-ref HEAD)" "${remote}" -- charts
}


# get all folders containing changed files
list_changed_dirs() {
  local remote=${1}
  check_changes "${remote}" | xargs dirname | sort -u
}

# check master or main
list_changes() {
  if check_changes "remotes/origin/master" > /dev/null 2>&1; then
    list_changed_dirs "remotes/origin/master"
  elif check_changes "remotes/origin/main" > /dev/null 2>&1; then
    list_changed_dirs "remotes/origin/main"
  else
    exit 0
  fi
}

# find chart dirs containing Chart.yaml
find_chart_dir() {
  local path=${1}
  find "${path}" -regextype sed -regex ".*/[cC]hart.yaml" -exec dirname {} \;
}

# declare array
ch_dir_array=()

# populate array with chart folders
for dir in $(list_changes); do
  ch_dir_array+=( "$(find_chart_dir "${dir}")" )
done

SCHEMA_LOCATION="https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master"

# validate charts
for chart in "${ch_dir_array[@]}"; do
  if [[ -z ${chart} ]]; then
    continue
  else
    helm template "${chart}" | kubeval --exit-on-error --strict --schema-location "${SCHEMA_LOCATION}" "$@"
  fi
done
