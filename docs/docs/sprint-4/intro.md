---
title: Introdução
sidebar_position: 1
slug: /sprint-4
---
 
# Introdução

Bem vindos a documentação da nossa Sprint 4 do projeto! Nessa Sprint tivemos um foco maior em integrar os microsserviços desenolvidos nas sprint anteriores.

## Arquitetura

- **Notificação**: O sistema de notificação possui a finalidade de informar o usuário sobre eventos da aplicação. Foi utilizado o Firebase para poder integrar essa feature ao sistema.
- **CI/CD**: Continuous Integration e Continuous Development (CI/CD) se trata de utilizar diversas práticas para criar uma esteira de desenvolvimento automatizada, validada por testes, a fim de acelerar e garantir o funcionamento das entregas. Na documentação desta sprint, foram comentadas maneiras de aplicar e como foi aplicado algumas práticas no nosos projeto.
- **Logging:** Implementamos uma estratégia de logging centralizada para monitorar e depurar os microsserviços. Utilizamos o Elasticsearch, Filebeat e Kibana para coletar, processar e visualizar logs em tempo real, a partir dos logs dos containers do Docker Compose, facilitando a identificação e resolução de problemas.

## Frontend
- **Finalização do fluxo do enfermeiro:** Integração de todo o fluxo de enfermeiro, com leitura de QR Code, requisições de medicamento, material e assistência, visualização de requisições e visualização dos detalhes de uma requisição em específico.

## Experiência do Usuário

- **Teste de Usabilidade - SUS:**
  O teste de usabilidade avalia quão fácil e intuitivo é para os usuários interagir com o sistema. Nesta sprint, um segundo tipo de Teste de Usabilidade foi aplicado, agora seguindo a métrica System Usability Scale (SUS). Esse teste consiste na aplicação de um teste utilizando a aplicação sem orientações, seguido de um formulário. O resultado final é o nível de usabilidade do sistema de 0 à 100.
