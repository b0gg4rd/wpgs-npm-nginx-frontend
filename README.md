# Webpack Getting Started NPM NGINX Frontend

The [getting started Webpack](https://webpack.js.org/guides/getting-started/) with NPM and NGINX Docker container.

## Requirements

  - Docker 18

## Building

### Setup

Create the user cache directory for NPM:


```bash
$ mkdir ~/.npm && \
  mkdir ~/.config
```

The first time just use, or when add one dependency:

```bash
$ docker run \
    -u $(id -u):$(grep docker /etc/group | awk -F\: '{print $3}') \
    --net=host \
    --rm \
    -w $(pwd) \
    -v /etc/group:/etc/group:ro \
    -v /etc/passwd:/etc/passwd:ro \
    -v $(pwd):$(pwd) \
    -v ${HOME}/.config:${HOME}/.config \
    -v ${HOME}/.npm:${HOME}/.npm \
    devopslinko/linkomx-node:10.16.3-alpine \
    npm install
```

For develop cycle use:

```bash
$ docker run \
    -u $(id -u):$(grep docker /etc/group | awk -F\: '{print $3}') \
    --net=host \
    --rm \
    -w $(pwd) \
    -v /etc/group:/etc/group:ro \
    -v /etc/passwd:/etc/passwd:ro \
    -v $(pwd):$(pwd) \
    -v ${HOME}/.config:${HOME}/.config \
    -v ${HOME}/.npm:${HOME}/.npm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    devopslinko/linkomx-node:10.16.3-alpine \
    npm start --build_profile=local
```

The _web front_ must be in the location `http://localhost/`.


