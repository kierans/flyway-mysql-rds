#! /bin/bash

#
# Using tag data from docker, find the latest version of a major version of flyway
#
# To get tag data run "https://hub.docker.com/v2/namespaces/flyway/repositories/flyway/tags?page_size=100&page=1"
# for every page in the result set
#
# $ cat tags.json | ./find-latest-version.sh 6
#

if [[ $# -lt 1 ]] ; then
  echo "Usage: $(basename $0) <major-version>"
  exit 1
fi

MAJOR=$1

jq -r \
  --arg major "$MAJOR" \
'
  [.[].name
    | select(startswith($major))
    | {orig: ., ver: split("-")[0] | split(".") | map(tonumber)}
  ]
  | sort_by(.ver)
  | last
  | .orig
'
