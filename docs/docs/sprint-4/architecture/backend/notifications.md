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