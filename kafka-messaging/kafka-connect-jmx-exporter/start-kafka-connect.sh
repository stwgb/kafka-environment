#!/bin/bash

./config-kafka-connect.sh

echo ">>> starting kafka-connect"
exec "/opt/kafka-connect/bin/connect-distributed.sh" "/opt/kafka-connect/config/connect-distributed.properties"