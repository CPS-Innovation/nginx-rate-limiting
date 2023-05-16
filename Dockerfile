FROM nginx:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
vim

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

ADD index.html /etc/nginx/html/index.html