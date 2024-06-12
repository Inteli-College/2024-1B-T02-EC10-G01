---
title: CI/CD
sidebar_position: 1
slug: /sprint-4
---

# CI/CD (Continuous Integration/Continuous Deployment)

CI/CD é um conjunto de práticas no desenvolvimento de software que visa a automação e melhoria contínua dos processos de integração, testes e implantação de código. As práticas de CI/CD trazem benefícios significativos, como maior velocidade de entrega, melhoria na qualidade do código, redução de riscos e feedback contínuo, tornando-se fundamentais para o desenvolvimento de software ágil e DevOps, especialmente em aplicações que precisam escalar rapidamente para atender a um número crescente de usuários.

No projeto que estamos desenvolvendo, a adoção de CI/CD pode gerar um grande diferencial e nos aproximar mais do nosso objetivo, que é criar uma aplicação com alta escalabilidade. Com estas práticas, é possível desenvolver um método de entrega eficiente e rápido, a fim de estar sempre crescendo e melhorando a aplicação.

## Backup

Backup consiste na capacidade de um sistema de identificar um erro na execução de um serviço(e.g. container de Banco de Dados), destruí-lo e substituir por uma réplica. Esta é uma das estratégias implementadas em uma pipeline de CI/CD a fim de rapidamente identificar falhas e se recompor. O uso de Backups é importante para reduzir o tempo de indisponibilidade e a perda de dados.

Uma das maneiras de aplicar essa estratégia é utilizando snapshots. Serviços com a AWS oferecem esse serviço por meio de AMIs. Um snapshot é uma imagem daquela instância que pode substituir aquele serviço, retrocedendo a versões com garantia de funcionamento.

### Estratégia de desastre

Um projeto de larga escala está suscetível a diversos tipos de desastres. Sejam ataques hackers ou próprios erros da aplicação, é importante se prever deles. Portanto em caso de desastres, em relação ao nosso projeto há algumas possibiilidades.

1. **Limpeza do Cache**: O sistema de Cache é essencial quando se trata de diminuir o tempo de resposta de aplicação, porém essa prática poder facilmente sobrecarregar a aplciação. Um cache pode superaquecer, isto é, se sobrecarregar de informações, replicando um banco de dados, porém com uma execução extremamente inferior, o que pode aumentar gerar erros diversos na aplciação.

2. **Reiniciar o Orquestrador**: Um orquestrador é uma parte essencial de uma aplicação com arquitetura em microserviços. Uma falha na sua execução pode comprometer toda a performance da aplicação. Com tamanha resposabilidade, o orquestardor, no nosso caso Kubernetes com contâiners em Docker, pode vir a sofrer falhas. Para isso se deve reiniciar o orquestrador, registrando e lançando os contâiners novamente.

3. **Monitoramento de Logs**: Uma das principais funções do sistema de logging é reportar eventos indesejados, que podem representar um mero aviso até a uma falha crítica do sistema. Por isso, revisá-los após um "crash" do sistema, é essencial para entender o que ocasionou esse desastre e como foi o processo até a falha.

## Logger

Como citada, outra estratégia que pode ser aplicada é de logger. O logger tem a finalidade de monitorar, dar transparência e traqueabilidade à aplicação, de modo que seja fácil rastrear eventos que ocorreram. Esse tipo de prática facilita na depuração e diagnóstico de falhas, aumentando a velocidade de tratamentos erros.

No projeto, o logger foi implementado utilizando RabbitMQ, onde as mensagem são postadas em um canal e depois são redirecionadas à um banco de dados PostgresSQL. Esta prática foi implementada especialmente pela necessidade de validar os dados durante o desenvolvimento de aplicação, uma vez que erros são mais recorrentemente nos estágios iniciais de desenvolvimento e é necessário rapidamente identificá-los, a fim de evoluir a aplicação de maneira mais eficiente e rápida. 
