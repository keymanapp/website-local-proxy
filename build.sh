#!/usr/bin/env bash
#
# Setup nginx reverse proxy via Docker.
#
## START STANDARD BUILD SCRIPT INCLUDE
# adjust relative paths as necessary
THIS_SCRIPT="$(greadlink -f "${BASH_SOURCE[0]}" 2>/dev/null || readlink -f "${BASH_SOURCE[0]}")"
. "$(dirname "$THIS_SCRIPT")/resources/builder.inc.sh"
## END STANDARD BUILD SCRIPT INCLUDE

################################ Main script ################################

# This script runs from its own folder
cd "$REPO_ROOT"

builder_describe \
  "Setup nginx reverse proxy site to run via Docker." \
  configure \
  clean \
  build \
  start \
  stop \

builder_parse "$@"

function get_docker_image_id() {
  echo "$(docker images -q reverse-proxy)"
}

function get_docker_container_id() {
  echo "$(docker ps -a -q --filter ancestor=reverse-proxy)"
}

function stop_docker_container() {
  local KEYMAN_CONTAINER=$(get_docker_container_id)
  if [ ! -z "$KEYMAN_CONTAINER" ]; then
    docker container stop $KEYMAN_CONTAINER
  else
    echo "No Docker container to stop"
  fi
}

builder_run_action configure true # nothing to do

if builder_start_action clean; then
  # Stop and cleanup Docker containers and images used for the site
  stop_docker_container

  KEYMAN_CONTAINER=$(get_docker_container_id)
  if [ ! -z "$KEYMAN_CONTAINER" ]; then
    docker container rm $KEYMAN_CONTAINER
  else
    echo "No Docker container to clean"
  fi
    
  KEYMAN_IMAGE=$(get_docker_image_id)
  if [ ! -z "$KEYMAN_IMAGE" ]; then
    docker rmi $KEYMAN_IMAGE
  else 
    echo "No Docker image to clean"
  fi

  builder_finish_action success clean
fi

# Stop the Docker container
builder_run_action stop stop_docker_container

if builder_start_action build; then
  # Download docker image. --mount option requires BuildKit  
  DOCKER_BUILDKIT=1 docker build -t reverse-proxy .

  builder_finish_action success build
fi

if builder_start_action start; then
  if [ -z "${KEYMAN_COM_PROXY_PORT+x}" ]; then
    KEYMAN_COM_PROXY_PORT=80
  fi  

  # Start the Docker container

 if [ -z $(get_docker_image_id) ]; then
    builder_die "ERROR: Docker container doesn't exist. Run ./build.sh build first"
  fi

  echo "starting docker run"
  ADD_HOST=
  if [[ $OSTYPE =~ linux-gnu ]]; then
    # Linux needs --add-host parameter
    ADD_HOST="--add-host host.docker.internal:host-gateway"
  fi
  echo "ADD_HOST: ${ADD_HOST}"

  docker run -d --rm \
    --name reverse-proxy-app \
    ${ADD_HOST} \
    -p 80:${KEYMAN_COM_PROXY_PORT} \
    reverse-proxy

  builder_finish_action success start
fi
