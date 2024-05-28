# Arquitetura de Orquestração
A orquestração do projeto Asky é composta por vários componentes Kubernetes, cada um desempenhando um papel crucial na infraestrutura. A seguir, detalhamos esses componentes e justificamos sua utilização.

## Namespace
Criamos um namespace específico chamado asky para isolar os recursos do projeto e evitar conflitos com outros aplicativos em execução no mesmo cluster.

```
kubectl create namespace asky
```

## Persistent Volumes e Persistent Volume Claims
Utilizamos Persistent Volumes (PVs) e Persistent Volume Claims (PVCs) para garantir o armazenamento persistente dos dados do PostgreSQL. Isso é essencial para assegurar que os dados do banco de dados sejam preservados entre reinicializações dos pods.

## ConfigMaps
ConfigMaps são utilizados para gerenciar configurações específicas dos serviços. No caso do Asky, utilizamos ConfigMaps para armazenar scripts de inicialização do banco de dados e configurações do gateway.

## Deployments e Services

Cada microserviço do Asky (autenticação, gateway, pyxis, e gerenciamento de requisições) é gerenciado através de objetos Deployment e Service do Kubernetes. Os Deployments garantem que o número desejado de réplicas de cada serviço esteja em execução, proporcionando alta disponibilidade e escalabilidade. Os Services expõem esses Deployments dentro do cluster e, no caso do gateway, externamente para permitir o acesso ao aplicativo.

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