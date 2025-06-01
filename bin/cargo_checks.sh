#!/usr/bin/env bash

set -xe

TARGETS=${TARGETS:-'--all-targets'}
FEATURES=${FEATURES:-'--all-features'}

cargo check ${TARGETS} ${FEATURES} $@
cargo fmt --all  $@ -- --check
cargo clippy ${TARGETS} ${FEATURES} $@ -- -D warnings -W clippy::all
