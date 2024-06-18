# Logging

## Visão Geral
O sistema de logging do projeto Asky utiliza Elasticsearch para armazenamento e busca de logs, Kibana para visualização e Filebeat para coleta de logs do Docker. Esta solução é integrada no ambiente de containers Docker, facilitando o monitoramento e a análise em tempo real dos logs de aplicação e sistema.

## Configuração do Docker Compose
O `docker-compose.yml` inclui a configuração dos serviços necessários para o sistema de logging, bem como outros serviços dependentes como Postgres, RabbitMQ e Redis. Abaixo estão detalhes específicos para os serviços de logging:

## Elasticsearch
Elasticsearch é configurado como um serviço que armazena e permite a busca dos logs. A configuração inclui:

- **Portas:** Exposição das portas 9200 e 9300 para acesso HTTP e comunicação entre nodes do cluster.
- **Volumes:** Um volume persistente elasticsearch_data para garantir que os dados não sejam perdidos entre reinicializações do container.

## Kibana
Kibana é utilizado para visualizar os logs armazenados no Elasticsearch. Configurações chave incluem:

- **Portas:** Exposição da porta 5601 para acesso à interface web.
- **Dependências:** Dependência explícita do Elasticsearch para garantir que o Kibana só inicie após o Elasticsearch estar operacional.
  
## Filebeat
Filebeat é configurado para coletar logs de containers Docker. Suas principais configurações são:

- **Autodescoberta:** Configurado para autodescobrir serviços em um ambiente Kubernetes, coletando logs diretamente dos paths dos logs de containers.
- **Processadores:** Uso do `add_docker_metadata` para enriquecer logs com metadados do Docker.
- **Output:** Configurado para enviar logs diretamente para o Elasticsearch, especificando o host, credenciais e formato dos índices.
