# Riak at Formational
#
# VERSION       0.0.2

FROM hectcastro/riak:latest
MAINTAINER Ralph Hebb rkhebb@gmail.com

#RUN sed -i.bak 's/%% Riak Client APIs config/%% Riak Client APIs config\n{ kernel, [\n            {inet_dist_listen_min, 6000},\n            {inet_dist_listen_max, 6010}\n          ]},/' /etc/riak/app.config

RUN echo "erlang.distribution.port_range.minimum = 6000" >> /etc/riak/riak.conf
RUN echo "erlang.distribution.port_range.maximum = 6010" >> /etc/riak/riak.conf

EXPOSE 4369 6001 6002 6003 6004 6005 6006 6007 6008 6009 6010 8087 8098 8099

ADD etcd_clustering.sh /etc/my_init.d/99_etcd_clustering.sh