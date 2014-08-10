# Riak at Formational
#
# VERSION       0.0.1

FROM hectcastro/riak:latest
MAINTAINER Ralph Hebb rkhebb@gmail.com

RUN sed -i.bak 's/%% Riak Client APIs config/%% Riak Client APIs config\n{ kernel, [\n            {inet_dist_listen_min, 6000},\n            {inet_dist_listen_max, 6010}\n          ]},/' /etc/riak/app.config

EXPOSE 8098 8087 4369 6001 6002 6003 6004 6005 6006 6007 6008 6009 6010

ADD etcd_clustering.sh /etc/my_init.d/99_etcd_clustering.sh
