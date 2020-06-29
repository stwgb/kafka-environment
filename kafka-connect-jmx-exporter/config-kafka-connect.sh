#!/bin/bash

CONFIG_FILE="/opt/kafka-connect/config/connect-distributed.properties"

echo ">>> Start to configure kafka connect"

if [[ -z "$BOOTSTRAP_SERVERS" ]]; then
    echo ">>> BOOTSTRAP_SERVERS not set, using DEFAULT"; else
    echo ">>> Setting bootstrap.server to $BOOTSTRAP_SERVERS"
    sed -i "s/bootstrap.servers=.*/bootstrap.servers=$BOOTSTRAP_SERVERS/" $CONFIG_FILE
fi

if [[ -z "$GROUP_ID" ]]; then
    echo ">>> GROUP_ID not set, using DEFAULT"; else
    echo ">>> Setting group.id to $GROUP_ID"
    sed -i "s/group.id=.*/group.id=$GROUP_ID/" $CONFIG_FILE
fi

if [[ -z "$KEY_CONVERTER" ]]; then
    echo ">>> KEY_CONVERTER, not set, using DEFAULT"; else
    echo ">>> Setting key.converter to $KEY_CONVERTER"
    sed -i "s/key.converter=.*/key.converter=$KEY_CONVERTER/" $CONFIG_FILE
fi

if [[ -z "$VALUE_CONVERTER" ]]; then
    echo ">>> VALUE_CONVERTER not set, using DEFAULT"; else
    echo ">>> Setting value.converter to $VALUE_CONVERTER"
    sed -i "s/value.converter=.*/value.converter=$VALUE_CONVERTER/" $CONFIG_FILE
fi

if [[ -z "$KEY_CONVERTER_SCHEMA_ENABLE" ]]; then
    echo ">>> KEY_CONVERTER_SCHEMA_ENABLE not set, using DEFAULT"; else
    echo ">>> Setting key.converter.schema.enable to $KEY_CONVERTER_SCHEMA_ENABLE"
    sed -i "s/key.converter.schema.enable=.*/key.converter.schema.enable=$KEY_CONVERTER_SCHEMA_ENABLE/" $CONFIG_FILE
fi

if [[ -z "$VALUE_CONVERTER_SCHEMA_ENABLE" ]]; then
    echo ">>> VALUE_CONVERTER_SCHEMA_ENABLE not set, using DEFAULT"; else
    echo ">>> Setting value.converter.schema.enable to $VALUE_CONVERTER_SCHEMA_ENABLE"
    sed -i "s/value.converter.schema.enable=.*/value.converter.schema.enable=$VALUE_CONVERTER_SCHEMA_ENABLE" $CONFIG_FILE
fi

if [[ -z "$OFFSET_STORAGE_TOPIC" ]]; then
    echo ">>> OFFSET_STORAGE_TOPIC not set, using DEFAULT"; else
    echo ">>> Setting offset.storage.topic to $OFFSET_STORAGE_TOPIC"
    sed -i "s/offset.storage.topic=.*/offset.storage.topic=$OFFSET_STORAGE_TOPIC/" $CONFIG_FILE
fi

if [[ -z "$OFFSET_STORAGE_REPLICATION_FACTOR" ]]; then
    echo ">>> OFFSET_STORAGE_REPLICATION_FACTOR not set, using DEFAULT"; else
    echo ">>> Setting offset.storage.replication.factor to $OFFSET_STORAGE_REPLICATION_FACTOR"
    sed -i "s/offset.storage.replication.factor=.*/offset.storage.replication.factor=$OFFSET_STORAGE_REPLICATION_FACTOR/" $CONFIG_FILE
fi

if [[ -z "$OFFSET_STORAGE_PARTITIONS" ]]; then
    echo ">>> OFFSET_STORAGE_PARTITIONS not set, using DEFAULT"; else
    echo ">>> Setting offset.storage.partitions to $OFFSET_STORAGE_PARTITIONS"
    sed -i "s/#offset.storage.partitions=.*/offset.storage.partitions=$OFFSET_STORAGE_PARTITIONS/" $CONFIG_FILE
fi

if [[ -z "$CONFIG_STORAGE_TOPIC" ]]; then
    echo ">>> CONFIG_STORAGE_TOPIC not set, using DEFAULT"; else
    echo ">>> Setting config.storage.topic to $CONFIG_STORAGE_TOPIC"
    sed -i "s/config.storage.topic=.*/config.storage.topic=$CONFIG_STORAGE_TOPIC/" $CONFIG_FILE
fi

if [[ -z "$CONFIG_STORAGE_REPLICATION_FACTOR" ]]; then
    echo ">>> CONFIG_STORAGE_REPLICATION_FACTOR not set, using DEFAULT"; else
    echo ">>> Setting config.storage.replication.factor to $CONFIG_STORAGE_REPLICATION_FACTOR"
    sed -i "s/config.storage.replication.factor=.*/config.storage.replication.factor=$CONFIG_STORAGE_REPLICATION_FACTOR/" $CONFIG_FILE
fi

if [[ -z "$STATUS_STORAGE_REPLICATION_FACTOR" ]]; then
    echo ">>> STATUS_STORAGE_REPLICATION_FACTOR not set, using DEFAULT"; else
    echo ">>> Setting status.storage.topic to $STATUS_STORAGE_REPLICATION_FACTOR"
    sed -i "s/status.storage.topic=.*/status.storage.topic=$STATUS_STORAGE_REPLICATION_FACTOR/" $CONFIG_FILE
fi

if [[ -z "$OFFSET_STORAGE_REPLICATION_FACTOR" ]]; then
    echo ">>> OFFSET_STORAGE_REPLICATION_FACTOR not set, using DEFAULT"; else
    echo ">>> Setting status.storage.replication.factor to $OFFSET_STORAGE_REPLICATION_FACTOR"
    sed -i "s/status.storage.replication.factor=.*/status.storage.replication.factor=$OFFSET_STORAGE_REPLICATION_FACTOR/" $CONFIG_FILE
fi

if [[ -z "$STATUS_STORAGE_PARTITIONS" ]]; then
    echo ">>> STATUS_STORAGE_PARTITIONS not set, using DEFAULT"; else
    echo ">>> Setting status.storage.partitions to $STATUS_STORAGE_PARTITIONS"
    sed -i "s/#status.storage.partitions=.*/status.storage.partitions=$STATUS_STORAGE_PARTITIONS/" $CONFIG_FILE
fi

if [[ -z "$OFFSET_FLUSH_INTERVAL_MS" ]]; then
    echo ">>> OFFSET_FLUSH_INTERVAL_MS not set, using DEFAULT"; else
    echo ">>> Setting offset.flush.interval.ms to $OFFSET_FLUSH_INTERVAL_MS"
    sed -i "s/offset.flush.interval.ms.*/offset.flush.interval.ms=$OFFSET_FLUSH_INTERVAL_MS/" $CONFIG_FILE
fi

if [[ -z "$REST_HOST_NAME" ]]; then
    echo ">>> REST_HOST_NAME not set, using DEFAULT"; else
    echo ">>> Setting rest.host.name to $REST_HOST_NAME"
    sed -i "s/#rest.host.name=.*/rest.host.name=$REST_HOST_NAME/" $CONFIG_FILE
fi

if [[ -z "$REST_PORT" ]]; then
    echo ">>> REST_PORT not set, using DEFAULT"; else
    echo ">>> Setting rest.host.name to $REST_PORT"
    sed -i "s/#rest.port=.*/rest.port=$REST_PORT/" $CONFIG_FILE
fi

if [[ -z "$REST_ADVERTISED_HOST_NAME" ]]; then
    echo ">>> REST_ADVERTISED_HOST_NAME not set, using DEFAULT"; else
    echo ">>> Setting rest.advertised.host.name to $REST_ADVERTISED_HOST_NAME"
    sed -i "s/#rest.advertised.host.name=.*/rest.advertised.host.name=$REST_ADVERTISED_HOST_NAME/" $CONFIG_FILE
fi

if [[ -z "$REST_ADVERTISED_PORT" ]]; then
    echo ">>> REST_ADVERTISED_PORT not set, using DEFAULT"; else
    echo ">>> Setting rest.advertised.port to $REST_ADVERTISED_PORT"
    sed -i "s/#rest.advertised.port=.*/rest.advertised.port=$REST_ADVERTISED_PORT/" $CONFIG_FILE
fi

if [[ -z "$PLUGIN_PATH" ]]; then
    echo ">>> PLUGIN_PATH not set, using DEFAULT"
    sed -i "s/#plugin.path=.*/plugin.path=\/opt\/connectors/" $CONFIG_FILE; else
    PLUGIN_PATH="\/opt\/connectors,$PLUGIN_PATH"
    echo ">>> Setting plugin.path to $PLUGIN_PATH"
    sed -i "s/#plugin.path=.*/plugin.path=$PLUGIN_PATH/" $CONFIG_FILE
fi

cat $CONFIG_FILE

echo "<<< finished configuration of kafka connect"
