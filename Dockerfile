# syntax=docker/dockerfile:1
FROM nginx:latest@sha256:10d1f5b58f74683ad34eb29287e07dab1e90f10af243f151bb50aa5dbb4d62ee
COPY resources/nginx.conf /etc/nginx/conf.d/default.conf
