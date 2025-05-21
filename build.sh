#!/usr/bin/env bash
## START STANDARD SITE BUILD SCRIPT INCLUDE
readonly THIS_SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
readonly BOOTSTRAP="$(dirname "$THIS_SCRIPT")/resources/bootstrap.inc.sh"
readonly BOOTSTRAP_VERSION=v1.0.2
[ -f "$BOOTSTRAP" ] && source "$BOOTSTRAP" || source <(curl -fs https://raw.githubusercontent.com/keymanapp/shared-sites/$BOOTSTRAP_VERSION/bootstrap.inc.sh)
## END STANDARD SITE BUILD SCRIPT INCLUDE

readonly PROXY_CONTAINER_NAME=local-proxy-website
readonly PROXY_CONTAINER_DESC=local-proxy-app
readonly PROXY_IMAGE_NAME=local-proxy-website
readonly HOST_PROXY=local-proxy-website.localhost

source _common/keyman-local-ports.inc.sh
source _common/docker.inc.sh

# This script runs from its own folder
cd "$REPO_ROOT"

################################ Main script ################################


builder_describe \
  "Setup nginx reverse proxy site to run via Docker." \
  configure \
  clean \
  build \
  start \
  stop \

builder_parse "$@"

builder_run_action configure bootstrap_configure
builder_run_action clean     clean_docker_container $PROXY_IMAGE_NAME $PROXY_CONTAINER_NAME
builder_run_action stop      stop_docker_container  $PROXY_IMAGE_NAME $PROXY_CONTAINER_NAME
builder_run_action build     build_docker_container $PROXY_IMAGE_NAME $PROXY_CONTAINER_NAME
builder_run_action start     start_docker_container $PROXY_IMAGE_NAME $PROXY_CONTAINER_NAME $PROXY_CONTAINER_DESC $HOST_PROXY 80
