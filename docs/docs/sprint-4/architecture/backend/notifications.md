---
title: Notificações
sidebar_position: 1
---

# Implementação de Serviços de Notificação

O aplicativo Asky precisa ser preciso, informativo e exato para cumprir seu propósito. O sistema de notificações facilita esse trabalho, permitindo que essas métricas sejam alcançadas. Utilizando o Firebase, notificações podem ser enviadas a qualquer momento e de qualquer lugar para enfermeiros e agentes, entregando informações importantes em tempo real.

## Firebase

Nossa solução foi implementada utilizando os serviços do Firebase, facilitando sua integração tanto na parte do framework Flutter quanto na parte do backend da solução. Além disso, o uso do Firebase torna nossa aplicação mais segura, pois todas as requisições são tratadas internamente, evitando requisições externas não autorizadas. Atualmente, utilizamos os serviços de Firebase Core, Firebase Messaging e Firebase Admin para orquestrar e manusear as requisições conforme necessário.

## Para que estamos utilizando?

Atualmente, utilizamos o serviço de notificações para facilitar as atualizações enviadas pelo aplicativo, tanto por agentes quanto por enfermeiros. Implementamos uma arquitetura em que, assim que um novo pedido é registrado, o agente recebe automaticamente uma notificação informando sobre uma nova necessidade dos enfermeiros. Conforme o agente executa o pedido, o enfermeiro recebe atualizações de status. As notificações são enviadas apenas aos membros relevantes para o processo em andamento.

## Como funciona?

Para que as notificações funcionem, capturamos um endereço chamado "mobile_token" assim que o usuário realiza o login. Este token é específico para cada dispositivo e cada instalação do aplicativo. Isso facilita o processo em caso de troca de dispositivo ou atualização do aplicativo. Além disso, deixamos funções pré-definidas para o envio das notificações, permitindo o envio para um usuário específico ou para um grupo de usuários com o mesmo cargo, facilitando a implementação de ações futuras, caso necessário.

## Benefícios das Notificações em Tempo Real

A implementação de notificações em tempo real oferece vários benefícios significativos para o aplicativo Asky:

### Melhoria na Comunicação

As notificações garantem que as informações críticas sejam entregues imediatamente aos usuários certos, melhorando a comunicação entre enfermeiros e agentes. Isso reduz o tempo de resposta e aumenta a eficiência no atendimento das solicitações.

### Acompanhamento de Processos

Com o sistema de notificações, enfermeiros e agentes podem acompanhar o status dos pedidos em tempo real. Isso oferece maior transparência e controle sobre os processos em andamento, permitindo uma gestão mais eficaz das tarefas.

### Aumento da Produtividade

Ao receber notificações instantâneas, os usuários podem agir rapidamente sobre novas informações, aumentando a produtividade e a capacidade de resposta às demandas. Isso é particularmente importante em ambientes de alta pressão, como o atendimento de saúde.

### Segurança da Informação

Utilizando o Firebase, garantimos que todas as notificações sejam enviadas de forma segura e confiável. As requisições internas são protegidas contra acessos não autorizados, assegurando a integridade e a privacidade dos dados dos usuários.
