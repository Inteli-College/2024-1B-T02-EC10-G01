---
title: Arquitetura de Orquestração
sidebar_position: 2
---

# Arquitetura de Orquestração
A orquestração do projeto Asky é uma peça fundamental para gerenciar a complexidade e assegurar a eficiência e escalabilidade do sistema. Utilizamos o Kubernetes como plataforma de orquestração devido às suas robustas capacidades de gerenciamento de containers, que são essenciais para lidar com os múltiplos componentes de nossa arquitetura de microserviços. Cada componente no Kubernetes desempenha um papel crucial na infraestrutura, permitindo a automatização de tarefas críticas como o escalonamento, o balanceamento de carga, a atualização contínua e a manutenção da saúde dos serviços.
Esta documentação descreve a orquestração do nosso aplicativo utilizando Kubernetes. O aplicativo é composto por vários componentes, incluindo ConfigMaps, Persistent Volumes, Deployments, Services, Ingress, entre outros.

## Estrutura dos Arquivos
- config_maps.yaml: Define os ConfigMaps utilizados pelo aplicativo.
- deployments.yaml: Define os deployments dos componentes principais do aplicativo.
- ingress.yaml: Configura o Ingress para gerenciar o tráfego de entrada e substituir a necessidade do uso de um container Nginx.
- namespace.yaml: Define o namespace onde todos os componentes do aplicativo serão implantados.
- persistent_volumes_and_claims.yaml: Define os volumes persistentes e suas respectivas claims.
- postgres-deployment.yaml: Define o deployment específico do PostgreSQL.
- postgres-service.yaml: Define o service para o PostgreSQL.
- services.yaml: Define os services necessários para o aplicativo.
- terminate.sh: Script para encerrar e limpar todos os recursos do Kubernetes.
- run.sh: Script para iniciar todos os recursos do Kubernetes.

## Configurações Importantes
### Ingress
O `ingress.yaml` é utilizado para substituir a necessidade de um container Nginx dentro do nosso aplicativo. O Ingress é um recurso do Kubernetes que gerencia o tráfego HTTP(S) de entrada para os serviços no cluster, proporcionando uma maneira de expor os serviços de forma segura e eficiente.

#### Como o Ingress Funciona
O Ingress atua como um ponto de entrada para o tráfego externo, direcionando solicitações para os serviços corretos com base em regras de roteamento. Ele pode ser configurado para oferecer suporte a várias funcionalidades, como:

- Balanceamento de Carga: Distribui o tráfego de entrada entre múltiplos pods, garantindo uma distribuição uniforme de carga e melhorando a disponibilidade e a resiliência do aplicativo.
- Regras de Roteamento: Permite a definição de regras para rotear o tráfego para diferentes serviços com base em caminhos ou hosts. Por exemplo, solicitações para app.example.com podem ser direcionadas para um serviço diferente de api.example.com.
- TLS/SSL: Suporta a configuração de certificados TLS/SSL, garantindo que o tráfego entre o cliente e o aplicativo seja criptografado e seguro.
- Autenticação e Autorização: Pode ser configurado para trabalhar com soluções de autenticação e autorização, protegendo o acesso aos serviços.

### Importância do Ingress em uma Arquitetura de Microsserviços
Em uma arquitetura de microsserviços, onde o aplicativo é dividido em vários serviços menores e independentes, o Ingress desempenha um papel crucial ao:

- Centralizar o Ponto de Entrada: Proporciona um ponto centralizado para gerenciar o tráfego de entrada, simplificando a configuração e o gerenciamento de roteamento.
- Facilitar a Comunicação entre Serviços: Permite que diferentes serviços sejam expostos externamente com regras de roteamento claras, facilitando a comunicação e a integração entre eles.
- Melhorar a Segurança: Ao suportar TLS/SSL, o Ingress garante que a comunicação entre os clientes e os serviços é segura, protegendo dados sensíveis.
- Aumentar a Flexibilidade e a Escalabilidade: Com funcionalidades como balanceamento de carga e roteamento baseado em regras, o Ingress ajuda a escalar serviços de maneira eficiente e a gerenciar mudanças na topologia dos serviços sem interromper o tráfego.

### Serviços
Os services definidos no services.yaml e postgres-service.yaml são utilizados para expor os pods internamente no cluster do Kubernetes. Cada service possui um IP estável e um nome DNS, permitindo que os pods se comuniquem de maneira previsível.

### Volumes Persistentes
Os volumes persistentes definidos em persistent_volumes_and_claims.yaml são utilizados para armazenar dados de maneira persistente. Isso é crucial para serviços como o PostgreSQL, que precisam de armazenamento de dados durável.

### Deployments
Os deployments definidos em deployments.yaml e postgres-deployment.yaml especificam como os pods devem ser implantados e gerenciados pelo Kubernetes. Eles incluem definições para réplicas, atualizações contínuas, e recuperação automática de falhas.

### Scripts de Automação
**run.sh**
O script run.sh é utilizado para iniciar todos os recursos do Kubernetes. Ele aplica todos os arquivos YAML necessários para configurar o ambiente completo do aplicativo.

**terminate.sh**
O script terminate.sh é utilizado para encerrar e limpar todos os recursos do Kubernetes. Ele remove todos os deployments, services, volumes, e outros recursos criados para o aplicativo.

## Instruções de Uso

Para iniciar o ambiente, execute:

```
minikube start
./run.sh
minikube tunnel
```
Encerramento do Ambiente
Para encerrar e limpar o ambiente, execute o script terminate.sh:

```
./terminate.sh
```