#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f /blast/ee-secret/jwtsecret ]]; then
  echo "Generating JWT secret"
  __secret1=$(head -c 8 /dev/urandom | od -A n -t u8 | tr -d '[:space:]' | sha256sum | head -c 32)
  __secret2=$(head -c 8 /dev/urandom | od -A n -t u8 | tr -d '[:space:]' | sha256sum | head -c 32)
  echo -n "${__secret1}""${__secret2}" > /blast/ee-secret/jwtsecret
fi

if [[ -O "/blast/ee-secret/jwtsecret" ]]; then
  chmod 666 /blast/ee-secret/jwtsecret
fi

__public_ip="--p2p.advertise.ip $(wget -qO- https://ifconfig.me/ip)"

if [[ -n "${DEPLOY_TAG}" ]]; then
  __rollup_url="https://raw.githubusercontent.com/blast-io/deployment/${DEPLOY_TAG}/${NETWORK}/rollup.json"
else
  __rollup_url="https://raw.githubusercontent.com/blast-io/deployment/master/${NETWORK}/rollup.json"
fi
curl \
  --fail \
  --show-error \
  --silent \
  --retry-connrefused \
  --retry-all-errors \
  --retry 5 \
  --retry-delay 5 \
  "${__rollup_url}" \
  -o /blast/config/rollup.json

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
exec "$@" ${__public_ip} ${CL_EXTRAS}
