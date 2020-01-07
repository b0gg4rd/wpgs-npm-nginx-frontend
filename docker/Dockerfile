FROM nginx:1.17.5-alpine

LABEL maintainer="fcruz@linko.mx"

ARG PROFILE

ENV TZ America/Mexico_City

COPY docker/default.conf /etc/nginx/conf.d/

COPY dist /usr/share/nginx/html/

EXPOSE 80

