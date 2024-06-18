---
title: Estratégias de CI/CD
sidebar_position: 1
---
# CI/CD (Continuous Integration/Continuous Deployment)

## Introdução
Esta documentação descreve a infraestrutura de CI/CD utilizada no projeto Asky, delineando as práticas adotadas para automação de builds, testes e deploy, assim como a gestão de configurações Kubernetes através de um script de implantação chamado `run.sh`. Esta infraestrutura é projetada para promover a entrega contínua com alta confiabilidade e segurança.

## Estrutura de Diretórios do Repositório
A organização dos diretórios no repositório do projeto Asky é essencial para o gerenciamento de múltiplos ambientes (desenvolvimento, teste e produção), facilitando a segregação e aplicação de configurações específicas de cada ambiente.

```
src/backend/k8/
│
├── dev/          # Arquivos de configuração para o ambiente de desenvolvimento
│   ├── config_maps.yaml
│   ├── deployments.yaml
│   ├── ingress.yaml
│   └── ...
│
├── test/         # Arquivos de configuração para o ambiente de testes
│   ├── config_maps.yaml
│   ├── deployments.yaml
│   ├── ingress.yaml
│   └── ...
│
└── main/         # Arquivos de configuração para o ambiente de produção
    ├── config_maps.yaml
    ├── deployments.yaml
    ├── ingress.yaml
    └── ...
```

## Configuração do GitHub Actions
O pipeline de CI/CD do Asky é implementado usando GitHub Actions, configurado para executar em resposta a eventos específicos.

### Triggers do Workflow
- **Pushes e Pull Requests:** O workflow é acionado em commits nos ramos dev, test e main.
- **Publicação de Releases:** Ativações adicionais ocorrem ao publicar releases, permitindo deploys automatizados.
- **Disparos Manuais:** O workflow pode ser disparado manualmente para deploys ad hoc ou testes de configurações específicas.

### Jobs Definidos no Workflow
1. **Checkout do Código:** Utiliza actions/checkout@v4 para obter a versão mais recente do código no ramo especificado.
2. **Preparação do Docker Buildx:** Configura o Buildx para suportar a construção de imagens multi-arquitetura usando docker/setup-buildx-action@v1.
3. **Autenticação no Docker Hub:** Autentica no Docker Hub com credenciais armazenadas em segurança, permitindo o push de imagens.
4. **Construção e Push das Imagens Docker:** As imagens são construídas e enviadas para o Docker Hub com tags que indicam o ambiente (dev, test, main) usando docker/build-push-action@vX.
5. **Script de Implantação Kubernetes** (`run.sh`)
   
O `run.sh` é um script Bash utilizado para aplicar manualmente as configurações Kubernetes. Este script permite flexibilidade e controle detalhado durante o processo de implantação, essencial para operações críticas. Para executá-lo, basta rodar:

```
./run.sh [branch]
```

Baseado no argumento fornecido (dev, test, main), o script aplica as configurações do ambiente correspondente. Ele também monitora o status dos serviços, aguarda a prontidão dos pods e verifica os logs para confirmar a inicialização bem-sucedida dos componentes.

## Estratégia de desastre
Um projeto de larga escala está suscetível a diversos tipos de desastres. Sejam ataques hackers ou próprios erros da aplicação, é importante se prever deles. Portanto em caso de desastres, em relação ao nosso projeto há algumas possibiilidades.

**Limpeza do Cache:** O sistema de Cache é essencial quando se trata de diminuir o tempo de resposta de aplicação, porém essa prática poder facilmente sobrecarregar a aplciação. Um cache pode superaquecer, isto é, se sobrecarregar de informações, replicando um banco de dados, porém com uma execução extremamente inferior, o que pode aumentar gerar erros diversos na aplciação.

**Reiniciar o Orquestrador:** Um orquestrador é uma parte essencial de uma aplicação com arquitetura em microserviços. Uma falha na sua execução pode comprometer toda a performance da aplicação. Com tamanha resposabilidade, o orquestardor, no nosso caso Kubernetes com contâiners em Docker, pode vir a sofrer falhas. Para isso se deve reiniciar o orquestrador, registrando e lançando os contâiners novamente.

**Monitoramento de Logs:** Uma das principais funções do sistema de logging é reportar eventos indesejados, que podem representar um mero aviso até a uma falha crítica do sistema. Por isso, revisá-los após um "crash" do sistema, é essencial para entender o que ocasionou esse desastre e como foi o processo até a falha.

## Conclusão
O setup de CI/CD detalhado nesta documentação garante que o projeto Asky possa operar com eficiência e segurança, automatizando a maior parte do processo de entrega enquanto mantém a flexibilidade para intervenções manuais quando necessário, garantindo assim a estabilidade e a performance otimizada para cada ambiente específico.