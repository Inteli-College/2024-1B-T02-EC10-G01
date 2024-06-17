FROM docker.elastic.co/elasticsearch/elasticsearch:8.13.4

COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml:ro,Z

ENV node.name=elasticsearch

ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"

ENV discovery.type=single-node

ENV ELASTIC_USERNAME=elastic

ENV ELASTIC_PASSWORD=senha

ENV xpack.security.enabled=false

ENV http.host=0.0.0.0

EXPOSE 9200 9300

