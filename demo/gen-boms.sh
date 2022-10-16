#!/bin/sh

## purpose: generate example reguslts from the demos

set -e

THIS_DIR="$(dirname "$0")"
BIN_CDX_N="$(realpath "$THIS_DIR/../bin/cyclonedx-npm-cli.js")"
npm_execpath="${npm_execpath:-npm}"

for package in $THIS_DIR/*/project/package.json
do
  echo ">>> $package"
  project="$(dirname "$package")"
  result_dir="$(dirname "$project")/example-results"

  rm -rf "$result_dir"
  mkdir -p "$result_dir"
  "$npm_execpath" --prefix "$project" install

  for format in 'json' 'xml'
  do
    for spec in '1.2' '1.3' '1.4'
    do
      echo ">>> $result_dir $spec $format"
      node -- "$BIN_CDX_N" \
      --spec-version "$spec" \
      --output-reproducible \
      --output-format "$format" \
      --output-file "$result_dir/bom.$spec.$format" \
      "$package"
    done
  done
done