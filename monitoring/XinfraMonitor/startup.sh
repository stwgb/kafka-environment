#!/bin/bash

CONFIG_FILE="/kafka-monitor/config/xinfra-monitor.properties"

echo ">>> Start to configure kafka connect"

#if [[ -z "$BOOTSTRAP_SERVERS" ]]; then
#    echo ">>> BOOTSTRAP_SERVERS not set, using DEFAULT"; else
#    echo ">>> Setting bootstrap.server to $BOOTSTRAP_SERVERS"
    #sed -i "s/\"bootstrap.servers\":.*/\"bootstrap.servers\": \"$BOOTSTRAP_SERVERS\",/" $CONFIG_FILE
    #sed -i "1,/bootstrap.servers/s/\"bootstrap.servers\":.*/\"bootstrap.servers\": \"$BOOTSTRAP_SERVERS\",/" $CONFIG_FILE
#fi

#if [[ -z "$BOOTSTRAP_SERVERS" ]]; then
#    echo ">>> BOOTSTRAP_SERVERS not set, using DEFAULT"; else
#    echo ">>> Setting bootstrap.server to $BOOTSTRAP_SERVERS"
#    sed -i "s/\"bootstrap.servers\":.*/\"bootstrap.servers\": \"$BOOTSTRAP_SERVERS\"/1" $CONFIG_FILE
    #sed -i "3,/bootstrap.servers/s/\"bootstrap.servers\":.*/\"bootstrap.servers\": \"$BOOTSTRAP_SERVERS\"/3" $CONFIG_FILE
#fi

#if [[ -z "$ZOOKEEPER_CONNECT" ]]; then
#    echo ">>> ZOOKEEPER_CONNECT not set, using DEFAULT"; else
#    echo ">>> Setting zookeeper.connect to $ZOOKEEPER_CONNECT"
    #sed -i "s/\"zookeeper.connect\":.*/\"zookeeper.connect\": \"$ZOOKEEPER_CONNECT\",/" $CONFIG_FILE
#    sed -i "1,/zookeeper.connect/s/\"zookeeper.connect\":.*/\"zookeeper.connect\": \"$ZOOKEEPER_CONNECT\",/" $CONFIG_FILE
#fi

#cat $CONFIG_FILE | grep bootstrap.servers



echo ">>> starting xmon"
exec "/kafka-monitor/bin/xinfra-monitor-start.sh" "/config/xinfra-monitor.properties" 

#exec "/kafka-monitor/bin/single-cluster-monitor.sh" "--topic" "xmonitor" "--broker-list" "$BOOTSTRAP_SERVERS" "--zookeeper" "$ZOOKEEPER_CONNECT"