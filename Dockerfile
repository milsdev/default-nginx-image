FROM nginx:1.10

RUN apt-get update
RUN apt-get install -y gettext-base
COPY nginx.vh.conf.tpl /root/nginx.vh.conf.tpl
RUN mkdir /var/log/nginx/log/

ENTRYPOINT envsubst '$SITE_PORT$SITE_HOST$FASTCGI_PATH$SITE_ROOT' < /root/nginx.vh.conf.tpl > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'