---
title: Arquitetura
sidebar_position: 3
---

# Mudanças da arquitetura da Sprint 1 para Sprint 5

Ao longo das sprints, várias mudanças foram realizadas na arquitetura do projeto para buscar soluções que trouxessem mais eficácia e eficiência. As principais alterações incluem:

## SQL x NoSQL

Inicialmente, considerou-se que a utilização de bancos de dados NoSQL seria a escolha mais adequada para o projeto, devido à estrutura de microserviços adotada. A flexibilidade na modelagem de dados oferecida pelos bancos NoSQL facilitaria a adaptação e a escalabilidade das operações. No entanto, após uma análise mais aprofundada, optou-se pela utilização de uma estrutura SQL.

Com a implementação de schemas distintos para cada microserviço, foi possível alcançar um isolamento eficaz das informações, proporcionando uma organização mais estruturada e consistente dos dados. Esta abordagem não só mantém a integridade e a coerência dos dados, mas também facilita a realização de operações complexas e consultas relacionais, que são importantes para o funcionamento eficiente da aplicação.

## Gerenciamento de eventos

Para lidar com as mudanças realizadas na solução, como mudanças de status, considerou-se inicialmente a utilização do Socket.IO. Essa ferramenta permite a criação de um canal de comunicação bidirecional em tempo real entre o cliente e o servidor, o que poderia ser útil para atualizar instantaneamente o status das requisições. No entanto, após uma análise mais aprofundada, optou-se por uma abordagem diferente.

Decidiu-se que seria mais adequado gerenciar esses eventos por meio de uma fila de mensagens e uma API de gerenciamento de eventos. Isso porque a complexidade adicionada pelo Socket.IO não seria justificada, uma vez que o objetivo de manter os usuários informados sobre as mudanças de status poderia ser alcançado de forma eficaz e escalável utilizando-se essas ferramentas.

Com essa abordagem, sempre que ocorrer uma mudança de status, uma mensagem seria colocada na fila de mensagens. A API de gerenciamento de eventos seria responsável por consumir essas mensagens da fila e atualizar o status das requisições de acordo. Isso garantiria um fluxo de trabalho eficiente e escalável, sem a necessidade de manter um canal de comunicação aberto o tempo todo.

Essa escolha também traz benefícios em termos de manutenção e escalabilidade. Ao utilizar uma fila de mensagens e uma API de gerenciamento de eventos, torna-se mais fácil adicionar novos tipos de eventos e escalar a aplicação conforme necessário, sem comprometer a performance ou a simplicidade do sistema.

## Monitoramento por logs

Inicialmente, não foi realizado um mapeamento das tecnologias que seriam utilizadas para o monitoramento da aplicação por meio de logs. No entanto, ao longo do desenvolvimento, foram adicionadas ao projeto tecnologias como o ElasticSearch e o Kibana para esse fim.

O ElasticSearch foi escolhido como mecanismo de busca e análise de logs devido à sua capacidade de armazenar grandes volumes de dados de forma eficiente e realizar buscas rápidas e avançadas. Ele permite a indexação dos logs gerados pela aplicação, facilitando a busca por informações específicas em meio a um grande volume de registros.

O Kibana, por sua vez, é uma interface de usuário que permite a visualização e análise dos dados armazenados no ElasticSearch. Com o Kibana, é possível criar dashboards personalizados, gráficos e visualizações que auxiliam na identificação de padrões, tendências e problemas na aplicação.

A integração do ElasticSearch e do Kibana no projeto proporcionou uma melhor visibilidade e controle sobre o funcionamento da aplicação, permitindo identificar e solucionar problemas de forma mais eficiente. Além disso, essa abordagem facilita a geração de relatórios e análises que podem ser utilizados para otimizar o desempenho e a experiência do usuário.

Essas tecnologias adicionadas ao projeto demonstram o compromisso com a qualidade e a eficiência da aplicação, garantindo que ela esteja sempre operando de forma adequada e atendendo às expectativas dos usuários.

# Como executar o Backend

Para rodar o projeto, utilizamos o Docker Compose. O arquivo docker-compose.yaml na raiz do projeto orquestra os contêineres Docker dos diversos microserviços. Para iniciar todos os serviços, basta executar o comando:

```
docker-compose up --build
```

Este comando irá construir as imagens Docker e iniciar todos os contêineres definidos no arquivo de composição, configurando o ambiente completo do backend do Asky.