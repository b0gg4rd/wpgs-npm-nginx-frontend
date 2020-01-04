#!/bin/sh
#
# Script functions for NPM frontend web
#
# This shell script contains the functions to some steps of the
# building lifecycle for NPM frontend web.

IMAGE_ID=$npm_package_name:$npm_package_version

image() {
  if [ -z $1 ]; then
    echo -e 'Usage:\n  ./scripts.sh image [local or dev or qa or prod]'
    exit 1
  fi

  case $1 in
    local|dev|qa|prod)
      docker rmi $IMAGE_ID
      docker build \
        --build-arg PROFILE=$1 \
        -f docker/Dockerfile \
        -t $IMAGE_ID \
        .
      ;;
    *)
      echo -e 'Usage:\n  ./scripts.sh image [local or dev or qa or prod]'
      exit 1
  esac
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

registry() {
  if [ -z $1 ]; then
    echo -e 'Usage:\n  ./scripts.sh registry [dev or qa or prod]'
    exit 1
  fi

  case $1 in
    dev)
      REPOSITORY_ID=$npm_package_config_registry_dev/$npm_package_name:$npm_package_version
      ;;
    qa)
      REPOSITORY_ID=$npm_package_config_registry_qa/$npm_package_name:$npm_package_version
      ;;
    prod)
      REPOSITORY_ID=$npm_package_config_registry_prod/$npm_package_name:$npm_package_version
      ;;
  esac

  if [ $1 = dev ] || [ $1 = qa ] || [ $1 = prod ]; then
    docker tag $IMAGE_ID $REPOSITORY_ID
    docker push $REPOSITORY_ID
  else
    echo -e 'Usage:\n  ./scripts.sh registry [dev or qa or prod]'
    exit 1
  fi

}

case "$1" in
  'image')
    image $2
    ;;
  'container')
    container $2
    ;;
  'registry')
    registry $2
    ;;
  *)
    echo -e 'Usage:\n  ./scripts.sh image [local or dev or qa or prod]'
    exit 1
esac

exit 0

