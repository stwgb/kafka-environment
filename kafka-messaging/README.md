# Kafka-Messaging

The kafka-messaging consists of

- a Zookeeper-Ensemble with three Zookeeper,
- a Kafka-Cluster with three Kafka-Brokers and
- one Kafka-Connect-Worker. 

## Running the environment

You can start the environment by running `docker-compose -f kafka-messaging-compose.yaml`. If the Docker-Images are not available,
Docker will build them for you. 