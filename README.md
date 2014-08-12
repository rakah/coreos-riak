coreos-riak
===========

Docker assets to initialize a Riak cluster on CoreOS

About
-----

This Docker repository can be deployed on CoreOS and uses the status of the
etcd cluster to coordinate startup of a Riak cluster.  If a cluster member is
found to be the primary for etcd, then it also becomes the initial node in the
Riak cluster.  I am currently running Docker containers on separate EC2
instances, not Docker containers on a single host.

Getting Started
---------------

I use the following systemd unit code in cloud-config to start my Riak cluster:

    - name: riak.service
      command: start
      content: |
        [Unit]
        Description=start Riak Docker containers
        After=etcd.service

        [Service]
        User=core
        RemainAfterExit=yes
        Restart=on-failure
        ExecStart=/usr/bin/docker run -e "DOCKER_RIAK_ETCD_CLUSTERING=1" -e "DOCKER_RIAK_CLUSTER_SIZE=3" -e "DOCKER_HOST_IP=$private_ipv4" -p 8098:8098 -p 8087:8087 -p 4369:4369 -p 6000:6000 -p 6001:6001 -p 6002:6002 -p 6003:6003 -p 6004:6004 -p 6005:6005 -p 6006:6006 -p 6007:6007 -p 6008:6008 -p 6009:6009 -p 6010:6010 -P -d rakah/coreos-riak
