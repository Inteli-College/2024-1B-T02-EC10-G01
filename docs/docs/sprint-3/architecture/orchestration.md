---
title: Arquitetura de Orquestração
sidebar_position: 2
---

# Arquitetura de Orquestração
A orquestração do projeto Asky é uma peça fundamental para gerenciar a complexidade e assegurar a eficiência e escalabilidade do sistema. Utilizamos o Kubernetes como plataforma de orquestração devido às suas robustas capacidades de gerenciamento de containers, que são essenciais para lidar com os múltiplos componentes de nossa arquitetura de microserviços. Cada componente no Kubernetes desempenha um papel crucial na infraestrutura, permitindo a automatização de tarefas críticas como o escalonamento, o balanceamento de carga, a atualização contínua e a manutenção da saúde dos serviços.

A seguir, detalhamos os componentes específicos e justificamos sua utilização no contexto do Asky.

## Namespace
Criamos um namespace específico chamado asky para isolar os recursos do projeto e evitar conflitos com outros aplicativos no mesmo cluster. Isso é crucial para manter o ambiente de produção organizado e seguro, especialmente quando várias instâncias de aplicativos estão sendo executadas.

```
kubectl create namespace asky
```

## Persistent Volumes e Persistent Volume Claims

Usamos Persistent Volumes (PVs) e Persistent Volume Claims (PVCs) para fornecer armazenamento persistente e confiável para o banco de dados PostgreSQL. Esses componentes são vitais para a funcionalidade de gerenciamento de requisições e autenticação, pois garantem que os dados cruciais dos usuários e registros de transações sejam mantidos seguros e intactos entre as reinicializações dos Pods.

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: postgres-pv-claim
  labels:
    app: postgres
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```

```
kind: PersistentVolume
apiVersion: v1
metadata:
  name: postgres-pv-volume
  labels:
    type: local
    app: postgres
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: "/mnt/data"
```

## ConfigMaps
ConfigMaps são utilizados para gerenciar configurações específicas dos serviços. No caso do Asky, utilizamos ConfigMaps para armazenar scripts de inicialização do banco de dados e configurações do gateway.

### ConfigMap postgres-initdb-config
Este ConfigMap contém um script SQL que inicializa a base de dados PostgreSQL com esquemas específicos para cada parte do aplicativo: pyxis, requests e auth. Este script não só cria esquemas e tabelas necessárias, mas também popula algumas delas com dados iniciais, facilitando a configuração e o início rápido do ambiente. Aqui estão alguns pontos importantes sobre este ConfigMap:

- Criação de Esquemas: Separa os dados por funções dentro do aplicativo, garantindo que a organização e manutenção do banco de dados sejam simplificadas.
- Tabelas e Relações: Define tabelas com relacionamentos, como dispenser_medicine, garantindo integridade referencial e facilitando consultas complexas.
- Segurança de Dados: Popula a tabela de usuários com hashes de senhas, o que é crucial para a segurança da autenticação.

### ConfigMap gateway-config
Este ConfigMap configura um servidor NGINX que atua como um proxy reverso, encaminhando requisições para os diferentes microserviços do Asky baseados em Kubernetes. Veja como ele beneficia o sistema:

- Roteamento Eficiente: Define regras de roteamento que direcionam as requisições para os microserviços apropriados, como pyxis, request_management e auth, com base no caminho da URL.
- Configuração de Proxy: Ajusta cabeçalhos específicos para assegurar que as requisições sejam tratadas corretamente pelos microserviços backend, incluindo cabeçalhos para suportar o correto encaminhamento de IPs e protocolos.
- Escalabilidade e Desempenho: Ao utilizar o NGINX, o ConfigMap permite que o tráfego seja gerenciado de forma eficiente, beneficiando-se das capacidades de alto desempenho do NGINX como balanceador de carga e servidor de conteúdo estático.

## Deployments e Services

Cada microserviço no Asky (como autenticação, gateway, pyxis e gerenciamento de requisições) é gerenciado através de objetos Deployment e Service. Os Deployments são cruciais para garantir alta disponibilidade e escalabilidade automática das aplicações. Eles são especialmente importantes para o serviço de gerenciamento de requisições e o serviço pyxis, onde a demanda pode flutuar significativamente, exigindo uma resposta rápida em termos de escalonamento. Os Services são essenciais para expor esses Deployments dentro do cluster e, no caso do gateway, também externamente, permitindo que os usuários acessem o aplicativo de maneira eficiente.

### PostgreSQL

- **Deployment:** Garante a execução do banco de dados PostgreSQL com a configuração necessária e persistência de dados.

- **Service:** Exponibiliza o banco de dados para outros serviços dentro do cluster

### Autenticação, Gateway, Pyxis e Gerenciamento de Requisições

- **Deployments:** Cada um desses serviços possui seu próprio Deployment, garantindo a disponibilidade e escalabilidade.

- **Services:** Os Services associados a esses Deployments permitem a comunicação entre os serviços dentro do cluster e expõem o gateway externamente para acesso dos usuários.

## Arquivos de Script
Para automatizar o processo de criação e destruição dos recursos no cluster Kubernetes, utilizamos scripts shell.

### Script de Inicialização (run.sh)
Este script automatiza a criação dos namespaces, volumes persistentes, ConfigMaps, Deployments e Services. Além disso, ele monitora o status dos pods para garantir que estejam prontos antes de prosseguir com a implantação dos próximos componentes.

### Script de Terminação (terminate.sh)
Este script automatiza a limpeza do ambiente, deletando o namespace, PVCs e PVs, garantindo que todos os recursos alocados sejam liberados.

## Estratégia de Réplicas
Cada microserviço é configurado com um número específico de réplicas para garantir alta disponibilidade e capacidade de lidar com aumentos de carga. O número de réplicas pode ser ajustado com base em testes de carga e requisitos de desempenho.

## Conclusão
A arquitetura de orquestração do projeto Asky no Minikube garante a robustez, escalabilidade e resiliência necessárias para um ambiente hospitalar crítico. Utilizando Kubernetes, conseguimos gerenciar eficientemente os diversos componentes da aplicação, assegurando alta disponibilidade e capacidade de resposta às variações de carga e demandas do sistema.