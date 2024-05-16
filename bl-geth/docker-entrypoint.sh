#!/usr/bin/env bash
set -euo pipefail

# Set verbosity
shopt -s nocasematch
case ${LOG_LEVEL} in
  error)
    __verbosity="--verbosity 1"
    ;;
  warn)
    __verbosity="--verbosity 2"
    ;;
  info)
    __verbosity="--verbosity 3"
    ;;
  debug)
    __verbosity="--verbosity 4"
    ;;
  trace)
    __verbosity="--verbosity 5"
    ;;
  *)
    echo "LOG_LEVEL ${LOG_LEVEL} not recognized"
    __verbosity=""
    ;;
esac

if [ ! -d /blast/geth/chaindata ]; then
  echo "Initializing from genesis."
  curl \
    --fail \
    --show-error \
    --silent \
    --retry-connrefused \
    --retry-all-errors \
    --retry 5 \
    --retry-delay 5 \
    "https://raw.githubusercontent.com/blast-io/deployment/master/${NETWORK}/genesis.json" \
    -o /blast/config/genesis.json

# Word splitting is desired for the command line parameters
# shellcheck disable=SC2086
  geth ${__verbosity} init --datadir=/blast --state.scheme=path /blast/config/genesis.json
fi

# Get extra env variables
curl \
  --fail \
  --show-error \
  --silent \
  --retry-connrefused \
  --retry-all-errors \
  --retry 5 \
  --retry-delay 5 \
  "https://raw.githubusercontent.com/blast-io/deployment/master/${NETWORK}/.config" \
  -o /blast/config/.config

source /blast/config/.config

# Word splitting is desired for the command line parameters
# shellcheck disable=SC2086
exec "$@" ${__verbosity} ${EL_EXTRAS}
