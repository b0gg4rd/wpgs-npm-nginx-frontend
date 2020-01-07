#!/bin/sh
#
# Script functions for NPM frontend web
#
# This shell script contains the functions to some steps of the
# building lifecycle for NPM frontend web.

IMAGE_ID=$npm_package_name:$npm_package_version

image() {
  docker rmi $IMAGE_ID
  docker build \
    -f docker/Dockerfile \
    -t $IMAGE_ID \
    .
}

container() {
  if [ -z $1 ]; then
    echo -e 'Usage:\n  ./scripts.sh container [start or restart or stop]'
    exit 1
  fi

  case $1 in
    start)
      docker run -d \
        --net=host \
        --rm \
        --name $npm_package_config_container_name \
        -v $(pwd)/dist:/usr/share/nginx/html \
        $npm_package_name:$npm_package_version
      ;;
    restart)
      docker restart $npm_package_config_container_name
      ;;
    stop)
      docker stop \
        $npm_package_config_container_name \
        2> /dev/null
      ;;
    *)
      echo -e 'Usage:\n  ./scripts.sh container [start or restart or stop]'
      exit 1
  esac
}

case "$1" in
  'image')
    image
    ;;
  'container')
    container $2
    ;;
  *)
    echo -e 'Usage:\n  ./scripts.sh image or ./script.sh container'
    exit 1
esac

exit 0

