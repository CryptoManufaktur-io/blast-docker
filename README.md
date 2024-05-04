# Overview

Docker Compose for Blast RPC node

`cp default.env .env`, then `nano .env` and adjust values for the right network

Meant to be used with [central-proxy-docker](https://github.com/CryptoManufaktur-io/central-proxy-docker) for traefik
and Prometheus remote write; use `:ext-network.yml` in `COMPOSE_FILE` inside `.env` in that case.

If you want the bl-geth RPC ports exposed locally, use `rpc-shared.yml` in `COMPOSE_FILE` inside `.env`.

The `./blastd` script can be used as a quick-start:

`./blastd install` brings in docker-ce, if you don't have Docker installed already.

`cp default.env .env`

`nano .env` and adjust variables as needed, particularly `NETWORK` as well as `L1_RPC` and `L1_RPC_KIND`.

`./blastd up`

To update the software, run `./blastd update` and then `./blastd up`

This is Blast Docker v1.0.0
