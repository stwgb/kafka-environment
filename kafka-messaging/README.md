# Kafka-Messaging

The kafka-messaging consists of

- a Zookeeper-Ensemble with three Zookeeper,
- a Kafka-Cluster with three Kafka-Brokers and
- one Kafka-Connect-Worker. 

## Running the environment

You can start the environment by running `docker-compose -f kafka-messaging-compose.yaml`. If the Docker-Images are not available,
Docker will build them for you. 

You need to adjust the listener configuration. Replace the current IP with the IP of the host where Kafka should run in 
`kafka-messaging-compose.yaml` file for all Kafka-Services:

 `KAFKA_ADVERTISED_LISTENERS: INSIDE://:9092,OUTSIDE://<HOST_IP>:9094`