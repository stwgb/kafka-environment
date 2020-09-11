# Monitoring

## Configuration

Change the targets in the `prometheus/prometheus.yaml` file to the hosts where your Zookeepers, Kafka-Brokers and Kafka-Connect
 are running and target to port of the jmx-exporter:  
```yaml
global:
    scrape_interval: 10s
    evaluation_interval: 10s
scrape_configs:
    - job_name: 'kafka'
      static_configs: 
        - targets:
            - <IP_KAFKA01>:2001 # kafka 1
            - <IP_KAFKA02>:2002 # kafka 2
            - <IP_KAFKA03>:2003 # kafka 3
    - job_name: 'zookeeper'
      static_configs: 
        - targets:
            - <IP_ZK01>:3001 # zookeeper 1
            - <IP_ZK02>:3002 # zookeeper 2
            - <IP_ZK03>:3003 # zookeeper 3  
    - job_name: 'kafka-connect'
      static_configs: 
        - targets:
            - <IP_KAFKA_CONNECT01>:4001 # kafka-connect 1
```

## Starting

Start the monitoring services by running `docker-compose -f monitoring-compose.yaml` up.

