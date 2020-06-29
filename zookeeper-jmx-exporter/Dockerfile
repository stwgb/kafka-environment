FROM zookeeper:3.6

RUN  mkdir /opt/jmx-exporter && \
    wget --output-document=/opt/jmx-exporter/java-exporter.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.13.0/jmx_prometheus_javaagent-0.13.0.jar  && \
    wget --output-document=/opt/jmx-exporter/zookeeper-jmx-config.yml https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/zookeeper.yaml &&  \
    ls /opt/jmx-exporter && \ 
    cat /opt/jmx-exporter/zookeeper-jmx-config.yml