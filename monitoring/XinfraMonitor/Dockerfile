# Repo of Xinfra Monitor https://github.com/linkedin/kafka-monitor

FROM openjdk:8-alpine

RUN apk update && \
    apk add curl bash git jq

RUN git clone https://github.com/linkedin/kafka-monitor.git && \
    cd kafka-monitor && \
    ./gradlew jar && \
    ls && \
    mkdir /config

COPY startup.sh /startup.sh
COPY xinfra-monitor.properties /config/xinfra-monitor.properties

RUN chmod +x /startup.sh 


EXPOSE 8000 8778

CMD ["./startup.sh"]