#!/usr/bin/env bash

CONFIG_FILE=/etc/elasticsearch/elasticsearch.yml

: ${CLUSTER_NAME:?"CLUSTER_NAME is required."}
echo "cluster.name: ${CLUSTER_NAME}" >> "$CONFIG_FILE"
echo "path.data: ${PATH_DATA:=/var/lib/elasticsearch/data}" >> "$CONFIG_FILE"
echo "path.logs: /var/log/elasticsearch" >> "$CONFIG_FILE"
echo ${DISCOVER_ZEN_MINIMUM_MASTER_NODES:+"discovery.zen.minimum_master_nodes: $DISCOVER_ZEN_MINIMUM_MASTER_NODES"} >> "$CONFIG_FILE"
echo "network.host: _non_loopback_" >> "$CONFIG_FILE"
echo ${DISCOVERY_ZEN_PING_UNICAST_HOSTS:+"discovery.zen.ping.unicast.hosts: $DISCOVERY_ZEN_PING_UNICAST_HOSTS"} >> "$CONFIG_FILE"

# Make the data folder
mkdir -p $PATH_DATA
chown -R elasticsearch:elasticsearch $PATH_DATA

# Run elasticsearch
exec gosu elasticsearch /usr/share/elasticsearch/bin/elasticsearch -Des.path.conf=/etc/elasticsearch