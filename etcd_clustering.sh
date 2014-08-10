#!/bin/bash

# etcd_clustering.sh - Bash init script to use etcd on CoreOS to initialize a Riak cluster
# At the moment, I'm just using etcd to figure out who the initial node in the ring should
# be.  

if [ "$DOCKER_RIAK_ETCD_CLUSTERING" = "1" ]
  then
  MAX_TRIES=5
  COUNT=0
  ETCD_PRIMARY=""
  while [ "$ETCD_PRIMARY" = "" ]
  do
    sleep 1
    # This will equal the ip address of the etcd primary 
    ETCD_PRIMARY=$(curl -sL http://$(/sbin/ip route|awk '/default/ { print $3 }'):7001/v2/admin/machines | sed 's/.*"state":"leader","clientURL":"http:\/\///' | cut -f 1 -d :)
    echo $ETCD_PRIMARY
    let COUNT=COUNT+1
    if [ $COUNT -gt $MAX_TRIES ]
    then
      echo Could not determine etcd leader
      exit 127
    fi
  done

  sed -i.bak s/127.0.0.1/$DOCKER_HOST_IP/ /etc/riak/vm.args
  if [ "$ETCD_PRIMARY" = "$DOCKER_HOST_IP" ]
  then
    echo ETCD_PRIMARY is $ETCD_PRIMARY
    # Our docker container is running on the etcd primary, so we should initiate the cluster
    riak start
  else
    riak start
    MAX_TRIES=120
    COUNT=0
    while [ "$RIAK_PING" != "OK" ]
    do
      sleep 2
      RIAK_PING=$(curl -s http://$ETCD_PRIMARY:8098/ping)
      echo RIAK_PING is $RIAK_PING
      let COUNT=COUNT+1
      if [ $COUNT -gt $MAX_TRIES ]
      then
        echo Could not get OK response from ETCD_PRIMARY riak
        exit 127
      fi
    done
    # Once first node is up we can join to it
    riak-admin cluster join "riak@$ETCD_PRIMARY"
    # Are we the last node to join?

    MAX_TRIES=120
    COUNT=0
    while [ "$(riak-admin member-status | grep -e joining -e valid | wc -l)" != "$DOCKER_RIAK_CLUSTER_SIZE" ]
    do
      sleep 2
      let COUNT=COUNT+1
      if [ $COUNT -gt $MAX_TRIES ]
      then
        echo Could not find the correct number of valid or joining ring members
        exit 127
      fi
    done
    riak-admin cluster plan
    riak-admin cluster commit
  fi
fi
