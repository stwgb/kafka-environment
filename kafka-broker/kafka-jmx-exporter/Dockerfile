FROM wurstmeister/kafka:2.12-2.5.0

RUN  mkdir /opt/jmx-exporter && \
    wget --output-document=/opt/jmx-exporter/java-exporter.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.13.0/jmx_prometheus_javaagent-0.13.0.jar  && \
    wget --output-document=/opt/jmx-exporter/kafka-jmx-config.yml https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/kafka-2_0_0.yml &&  \
    ls /opt/jmx-exporter && \ 
    cat /opt/jmx-exporter/kafka-jmx-config.yml