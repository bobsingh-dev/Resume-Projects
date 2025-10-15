SHELL := /bin/bash

.DEFAULT_GOAL := help

help:
	@echo "Targets: parta, parta-client, partb, partb-client, clean"

# ---------- Part A ----------
parta:
	@pushd parta-custom-certs && ./generate-certs.sh && popd
	@docker compose -f compose.yaml up --build parta-server -d
	@sleep 2
	@echo "Part A server up at https://localhost:8443"

parta-client:
	@docker compose -f compose.yaml run --rm parta-client

# ---------- Part B ----------
partb:
	@docker compose -f compose.yaml up --build spire-server spire-agent partb-server envoy-server -d
	@sleep 4
	@docker compose -f compose.yaml exec spire-server /bin/sh -c "/spire/registrations.sh && echo 'Entries registered'"
	@sleep 2
	@echo "Part B server (Envoy) listening on https://localhost:8444"

partb-client:
	@docker compose -f compose.yaml up --build partb-client envoy-client -d
	@sleep 3
	@docker compose -f compose.yaml logs -f partb-client

clean:
	@docker compose -f compose.yaml down -v --remove-orphans
	@rm -rf parta-custom-certs/certs
