# syntax=docker/dockerfile:1
FROM nginx:latest
COPY resources/nginx.conf /etc/nginx/conf.d/default.conf
