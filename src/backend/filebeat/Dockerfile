FROM docker.elastic.co/beats/filebeat:8.13.4

COPY filebeat.yml /usr/share/filebeat/filebeat.yml

USER root

RUN chown -R root /usr/share/filebeat/filebeat.yml
RUN chmod -R go-w /usr/share/filebeat/filebeat.yml

