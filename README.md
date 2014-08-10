coreos-riak
===========

Docker assets to initialize a Riak cluster on CoreOS

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
        #Environment="DOCKER_RIAK_DEBUG=true"
        #ExecStart=/bin/bash -c "RIAK_PRIMARY=$(curl -sL http://127.0.0.1:4001/v2/stats/self | cut -f 2 -d ',' | grep leader | wc -l)"
        ExecStart=/usr/bin/docker run -e "DOCKER_RIAK_ETCD_CLUSTERING=1" -e "DOCKER_RIAK_CLUSTER_SIZE=3" -e "DOCKER_HOST_IP=$private_ipv4" -p 8098:8098 -p 8087:8087 -p 4369:4369 -p 6000:6000 -p 6001:6001 -p 6002:6002 -p 6003:6003 -p 6004:6004 -p 6005:6005 -p 6006:6006 -p 6007:6007 -p 6008:6008 -p 6009:6009 -p 6010:6010 -P -d rakah/coreos-riak
