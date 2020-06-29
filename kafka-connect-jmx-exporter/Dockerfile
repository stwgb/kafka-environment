FROM openjdk:8-alpine

ENV SCALA_VERSION=2.13
ENV KAFKA_VERSION=2.5.0
ENV KAFKA_CONNECT_STARTUP=/kafka-connect-startup

# Updating and installing tools
RUN apk update && \
    apk add curl bash wget

# Download Kafka-Connect
RUN curl https://downloads.apache.org/kafka/2.5.0/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz --output /tmp/kafka-connect.tgz && \
    tar -xvzf /tmp/kafka-connect.tgz -C /opt && \
    mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka-connect && \
    ls /opt/kafka-connect

RUN ls /opt/kafka-connect/bin && \
    ls /opt/kafka-connect/config && \
    cat /opt/kafka-connect/config/connect-distributed.properties

RUN mkdir /opt/jmx-exporter && \
    wget --output-document=/opt/jmx-exporter/java-exporter.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.13.0/jmx_prometheus_javaagent-0.13.0.jar  && \
    wget --output-document=/opt/jmx-exporter/kafka-connect-jmx-config.yml https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/kafka-connect.yml &&  \
    ls /opt/jmx-exporter && \ 
    cat /opt/jmx-exporter/kafka-connect-jmx-config.yml

# Copy start-up scripts and make them executable
RUN mkdir ${KAFKA_CONNECT_STARTUP}
COPY config-kafka-connect.sh ${KAFKA_CONNECT_STARTUP}/config-kafka-connect.sh 
COPY start-kafka-connect.sh ${KAFKA_CONNECT_STARTUP}/start-kafka-connect.sh

RUN chmod -R +x ${KAFKA_CONNECT_STARTUP}

# Create plugin dir for connectors
RUN mkdir /opt/connectors
# VOLUME ["/opt/connectors"]

# Expose Ports
EXPOSE 8083/tcp
EXPOSE 8084/tcp

WORKDIR ${KAFKA_CONNECT_STARTUP}
CMD ["./start-kafka-connect.sh"]