---
title: User Stories
sidebar_position: 5
---

User stories são descrições curtas e simples de uma funcionalidade do sistema, escritas na perspectiva do usuário final. Elas descrevem quem é o usuário, o que ele deseja fazer e por que isso é importante. Essas histórias são importantes porque ajudam a manter o foco nas necessidades do usuário, facilitam o planejamento e a priorização das funcionalidades, permitem iterações rápidas e feedback contínuo, e promovem uma compreensão compartilhada entre a equipe de desenvolvimento, stakeholders e usuários finais.

## Persona: Enfermeiro

### 1. QR Code com informações do Pyxis

Como enfermeiro, quero escanear um QR Code com informações do Pyxis ao criar um pedido de urgência para que as informações relacionadas a ele já sejam preenchidas, sem que eu digite.

#### Critérios de aceitação:

- Ao escanear o QR Code, as informações relevantes do Pyxis (como medicamento, dosagem, número de lote) devem ser preenchidas automaticamente no formulário de pedido de urgência.

    a. Informações eram referentes ao Pyxis selecionado: Correto

    b. Informações não eram referentes ao Pyxis selecionado: Incorreto

- O enfermeiro deve ter a opção de revisar e confirmar as informações preenchidas pelo QR Code antes de finalizar o pedido de urgência.

- O escaneamento do QR Code deve ser rápido e preciso, garantindo que todas as informações sejam corretamente capturadas.

- O aplicativo deve fornecer feedback visual ou sonoro para indicar que o QR Code foi escaneado com sucesso e as informações foram preenchidas no formulário.

- Caso o QR Code esteja danificado ou não seja reconhecido, o aplicativo deve permitir que o enfermeiro preencha manualmente as informações necessárias.

    a. Preencheu todas as informações obrigatórias: Correto

    b. Não preencheu todas as informações obrigatórias: Incorreto


### 2. Autenticação de Usuário

Como enfermeiro, quero me autenticar no aplicativo para que minhas informações sejam salvas e utilizadas nos pedidos de urgência.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma tela de login onde o enfermeiro possa inserir suas credenciais (usuário e senha).

- As credenciais fornecidas pelo enfermeiro devem ser verificadas em um sistema de autenticação seguro.

    a. Caso as credenciais sejam válidas, o enfermeiro deve ser redirecionado para a tela principal do aplicativo.

    b. Caso as credenciais sejam inválidas, o aplicativo deve exibir uma mensagem de erro informando que a autenticação falhou.

- Após o login bem-sucedido, as informações do enfermeiro (como nome, identificação, etc.) devem ser armazenadas localmente no dispositivo para serem utilizadas nos pedidos de urgência.

- O aplicativo deve fornecer uma opção para o enfermeiro fazer logout, caso deseje sair da sua conta.

- O aplicativo deve manter o enfermeiro autenticado entre as sessões, para que ele não precise fazer login repetidamente.

- O processo de autenticação deve ser rápido e seguro, garantindo a proteção das informações do enfermeiro.


### 3. Atualizações em tempo real

Como enfermeiro, quero receber atualizações dos meus pedidos de urgência para acompanhar o reabastecimento do Pyxis e buscar meus medicamentos.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma seção ou página dedicada para o enfermeiro visualizar seus pedidos de urgência.

- Quando houver uma atualização em um pedido de urgência do enfermeiro (por exemplo, reabastecimento do Pyxis concluído), o aplicativo deve exibir uma notificação em tempo real.

- O enfermeiro deve poder ver o status atualizado de cada um de seus pedidos de urgência, incluindo se o pedido foi atendido e se os medicamentos estão disponíveis para retirada.

- O aplicativo deve permitir que o enfermeiro veja detalhes adicionais de cada pedido de urgência, como a data e hora em que foi feito, os medicamentos solicitados e a quantidade.

- As atualizações em tempo real devem ser precisas e rápidas, garantindo que o enfermeiro receba informações atualizadas sobre seus pedidos de urgência.


### 4. Seleção de medicamento e dosagem

Como enfermeiro, quero selecionar o medicamento e a dosagem sem precisar digitar todas as informações, gostaria de um autocomplete enquanto eu digito, tornando a operação mais rápida.

#### Critérios de aceitação:

- O aplicativo deve fornecer um campo de busca onde o enfermeiro possa digitar o nome do medicamento.

    a. Preencheu o campo obrigatório: Correto

    b. Não preencheu o campo obrigatório: Incorreto

- Enquanto o enfermeiro digita no campo de busca, o aplicativo deve exibir uma lista de sugestões de medicamentos que correspondam à entrada atual.

- O enfermeiro deve poder selecionar o medicamento desejado a partir da lista de sugestões, clicando nele ou navegando pela lista pressionando  para selecionar.

    a. Selecionou um medicamento: Correto

    b. Não selecionou um medicamento: Incorreto

- Após selecionar o medicamento, o aplicativo deve exibir opções para selecionar a dosagem apropriada, se houver mais de uma disponível.

- O enfermeiro deve poder selecionar a dosagem desejada a partir de uma lista suspensa ou outros controles intuitivos.

    a. Selecionou dosagem: Correto

    b. Não selecionou dosagem: Incorreto

- O aplicativo deve exibir uma confirmação clara do medicamento e da dosagem selecionados antes de prosseguir com o pedido de urgência.

- O processo de seleção de medicamento e dosagem deve ser rápido e eficiente, permitindo ao enfermeiro completar a operação de forma ágil.


### 5. Pedidos para a farmácia central

Como enfermeiro, quero poder fazer pedidos para a farmácia central para que meu pedido seja atendido mais rapidamente em casos de extrema necessidade.

#### Critérios de aceitação

- O aplicativo deve fornecer uma opção clara e acessível para o enfermeiro fazer um pedido direto para a farmácia central.

- Ao selecionar a opção de fazer um pedido para a farmácia central, o enfermeiro deve poder digitar qual o lote do seu pedido no Pyxis.

    a. Digitou o lote: Correto

    b. Não digitou o lote: Incorreto

- Após selecionar o lote, o enfermeiro deve confirmar o pedido, fornecendo informações adicionais, se necessário.

    a. Informações demonstradas condiziam com o lote: Correto

    b. Informações mostradas não condiziam com o lote: Incorreto

- Após o pedido ser confirmado, o aplicativo deve enviar automaticamente o pedido para a farmácia central.

- O pedido deve ser enviado de forma rápida e eficiente, garantindo que seja atendido o mais rapidamente possível em casos de extrema necessidade.

- O enfermeiro deve receber uma confirmação imediata do recebimento do pedido pela farmácia central.

- Se disponível, o pedido deve ser enviado para o enfermeiro por meio de um túnel pneumático, garantindo uma entrega rápida e segura.


### 6. Adição de lote em pedidos para a farmácia central

Como enfermeiro, quero adicionar o número de lote do medicamento para facilitar a busca de informações pela farmácia central.

#### Critérios de aceitação:

- O aplicativo deve fornecer um campo específico para o enfermeiro inserir o número de lote do medicamento ao fazer um pedido para a farmácia central.

- Após inserir o número de lote, o aplicativo deve exibir uma confirmação clara de que o número de lote foi registrado com sucesso.

- O número de lote fornecido pelo enfermeiro deve ser incluído no pedido enviado para a farmácia central.



## Persona: Auxiliar de farmácia

### 1. Visualização de solicitações

Como auxiliar de farmácia, quero visualizar todas as solicitações dos enfermeiros para realizar o reabastecimento do Pyxis.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma área ou página dedicada para o auxiliar de farmácia visualizar todas as solicitações dos enfermeiros.

- As solicitações devem ser apresentadas em uma lista clara e organizada, mostrando informações como o nome do medicamento, dosagem, quantidade solicitada, e status do pedido.

- Para cada solicitação, o auxiliar de farmácia deve poder ver detalhes adicionais, como a data e hora da solicitação, informações do enfermeiro solicitante, e quaisquer comentários adicionais feitos pelo enfermeiro.

- O aplicativo deve permitir que o auxiliar de farmácia marque uma solicitação como em andamento quando estiver preparando o reabastecimento do Pyxis, e como concluída quando o reabastecimento estiver completo.

- O auxiliar de farmácia deve poder enviar notificações aos enfermeiros para informar sobre o status de suas solicitações, como quando o reabastecimento estiver completo e os medicamentos estiverem disponíveis para retirada.


### 2. Autenticação de Usuário

Como auxiliar de farmácia, quero me autenticar no aplicativo para que meus dados sejam salvos e utilizados nas atribuições de urgências.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma tela de login onde o auxiliar de farmácia possa inserir suas credenciais (usuário e senha).

- As credenciais fornecidas pelo auxiliar de farmácia devem ser verificadas em um sistema de autenticação seguro.

    a. Caso as credenciais sejam válidas, o auxiliar de farmácia deve ser redirecionado para a tela principal do aplicativo.

    b. Caso as credenciais sejam inválidas, o aplicativo deve exibir uma mensagem de erro informando que a autenticação falhou.

- Após o login bem-sucedido, as informações do auxiliar de farmácia (como nome, identificação, etc.) devem ser armazenadas localmente no dispositivo para serem utilizadas nas atribuições de urgências.

- O aplicativo deve fornecer uma opção para o auxiliar de farmácia fazer logout, caso deseje sair da sua conta.

- O aplicativo deve manter o auxiliar de farmácia autenticado entre as sessões, para que ele não precise fazer login repetidamente.

- O processo de autenticação deve ser rápido e seguro, garantindo a proteção das informações do auxiliar de farmácia.


### 3. Atualização em tempo real

Como auxiliar de farmácia, quero enviar atualizações das solicitações para os solicitantes acompanharem o status.

#### Critérios de aceitação:

- O aplicativo deve permitir que o auxiliar de farmácia atualize o status de uma solicitação dos enfermeiros.

- Após atualizar o status de uma solicitação, o aplicativo deve enviar uma notificação para o enfermeiro solicitante informando sobre a atualização.

- O enfermeiro solicitante deve poder visualizar o status atualizado da sua solicitação na área dedicada a visualização de solicitações.

- O status da solicitação deve ser claro e informativo, indicando se o pedido está em andamento, concluído, ou se há alguma pendência.

- O aplicativo deve permitir que o auxiliar de farmácia adicione comentários adicionais à solicitação, se necessário, para explicar o status ou fornecer mais detalhes.

- As notificações enviadas para os enfermeiros solicitantes devem ser claras e informativas, fornecendo detalhes sobre a atualização da solicitação.


### 4. Feedbacks na solicitação 

Como auxiliar de farmácia, quero enviar feedbacks sobre as solicitações para os solicitantes, esclarecendo erros do usuário  ou detalhes específicos.

#### Critérios de aceitação:

- O aplicativo deve permitir que o auxiliar de farmácia envie feedbacks sobre as solicitações dos enfermeiros.

- O feedback deve ser enviado diretamente para o enfermeiro solicitante da solicitação específica.

- O feedback deve ser claro e informativo, explicando qualquer erro cometido pelo enfermeiro ou fornecendo detalhes específicos sobre a solicitação.

- O enfermeiro solicitante deve poder visualizar o feedback recebido na área dedicada a visualização de solicitações.

- O aplicativo deve permitir que o auxiliar de farmácia adicione comentários adicionais ao feedback, se necessário, para fornecer mais detalhes ou esclarecimentos.

- O feedback deve ser enviado de forma rápida e eficiente, garantindo que o enfermeiro receba a informação o mais rápido possível.

- O feedback deve ser enviado de forma privada, garantindo a confidencialidade das informações compartilhadas entre o auxiliar de farmácia e o enfermeiro solicitante.


### 5. Pedidos para o robô

Como auxiliar de farmácia, quero poder fazer pedidos para o robô para que ele já separe os medicamentos antes da minha chegada.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma interface para o auxiliar de farmácia selecionar os medicamentos que deseja pedir ao robô.

- O auxiliar de farmácia deve poder selecionar os medicamentos e suas respectivas dosagens de uma lista disponível no aplicativo.

- Após selecionar os medicamentos, o auxiliar de farmácia deve confirmar o pedido ao robô.

- O pedido confirmado deve ser enviado ao robô de forma automática e imediata.

- O robô deve receber o pedido e iniciar o processo de separação dos medicamentos antes da chegada do auxiliar de farmácia.

- O aplicativo deve fornecer uma confirmação ao auxiliar de farmácia de que o pedido foi recebido pelo robô e está sendo processado.

- O auxiliar de farmácia deve poder verificar o status do pedido ao robô a qualquer momento, para acompanhar o progresso da separação dos medicamentos.

- O robô deve separar os medicamentos de forma precisa e eficiente, garantindo que estejam prontos para retirada pelo auxiliar de farmácia quando ele chegar.



## Persona: Administração

### 1. Demonstração das métricas em gráficos

Como administrador, quero ter acesso a gráficos com métricas relevantes das operações de urgência para criar metas e identificar melhorias.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma seção ou página dedicada para o administrador visualizar os gráficos com as métricas relevantes das operações de urgência.

- Os gráficos devem apresentar as métricas de forma clara e intuitiva, utilizando cores e formas que facilitem a compreensão.

- Os gráficos devem incluir métricas como tempo médio de atendimento de pedidos, quantidade de pedidos por período de tempo, índice de pedidos atendidos dentro do prazo, entre outras métricas relevantes para as operações de urgência.

- O administrador deve poder selecionar o período de tempo que deseja visualizar nos gráficos, permitindo analisar tendências ao longo do tempo.

- Os gráficos devem ser interativos, permitindo ao administrador clicar em elementos para ver detalhes específicos ou filtrar os dados exibidos.

- Os gráficos devem ser atualizados em tempo real ou com uma frequência adequada, garantindo que as informações apresentadas sejam sempre atualizadas e precisas.

- Os gráficos devem ser responsivos, adaptando-se a diferentes tamanhos de tela para garantir uma boa experiência de visualização em dispositivos móveis e desktops.


### 2. Logs das operações

Como administrador, quero que logs sejam criados para cada operação de urgência para acompanhar de perto a operação.

#### Critérios de aceitação:

- O aplicativo deve gerar um log para cada operação de urgência realizada, registrando informações como data, hora, tipo de operação, usuário responsável, e detalhes específicos da operação.

- Os logs devem ser armazenados de forma segura e acessível apenas ao administrador ou usuários autorizados.

- O administrador deve poder visualizar os logs de operações em uma área dedicada do aplicativo.

- Os logs devem ser apresentados de forma organizada e fácil de entender, permitindo ao administrador identificar rapidamente informações relevantes.

- Os logs devem ser mantidos por um período de tempo adequado, conforme as políticas de retenção de dados da organização.

- Os logs devem ser atualizados em tempo real ou com uma frequência adequada, garantindo que as informações registradas sejam sempre atualizadas e precisas.


### 3. Autorização de Usuário

Como administrador, quero poder autorizar auxiliares de farmácia cadastrados para garantir a segurança do acesso.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma interface para o administrador gerenciar as autorizações de acesso dos auxiliares de farmácia.

- O administrador deve poder visualizar uma lista de todos os auxiliares de farmácia cadastrados no sistema.

- Para cada auxiliar de farmácia, o administrador deve poder autorizar ou revogar o acesso ao sistema.

- O administrador deve poder atribuir diferentes níveis de autorização para cada auxiliar de farmácia, permitindo controlar quais funcionalidades e informações cada um pode acessar.

- O processo de autorização deve ser simples e intuitivo, garantindo que o administrador possa realizar as ações necessárias com facilidade.

- O aplicativo deve manter um registro das autorizações concedidas e revogadas, incluindo a data e hora da ação e o administrador responsável.

- As autorizações concedidas devem ser aplicadas imediatamente, garantindo que os auxiliares de farmácia possam acessar as funcionalidades autorizadas sem problemas.

- O administrador deve poder receber notificações sobre solicitações de autorização pendentes, garantindo que nenhuma solicitação seja esquecida ou negligenciada.


### 4. Atualização em tempo real

Como administrador, quero ter acesso em tempo real aos status de cada pedido de urgência para acompanhar gargalos da operação.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma seção ou página dedicada para o administrador visualizar os status em tempo real de cada pedido de urgência.

- Os status dos pedidos devem ser atualizados automaticamente à medida que novas informações são recebidas pelo sistema.

- O administrador deve poder ver o status atualizado de cada pedido, incluindo se o pedido está pendente, em andamento, concluído ou se houve algum problema.

- O administrador deve poder visualizar detalhes adicionais de cada pedido, como informações do enfermeiro solicitante, medicamentos solicitados e quantidade.

- O aplicativo deve permitir que o administrador acesse os status dos pedidos de forma rápida e eficiente, sem a necessidade de atualizar a página manualmente.

- Os status dos pedidos devem ser apresentados de forma clara e intuitiva, permitindo ao administrador identificar rapidamente problemas ou gargalos na operação.

- O aplicativo deve garantir que as informações exibidas sejam sempre atualizadas e precisas, refletindo o status em tempo real de cada pedido.


### 5. Identificação de urgências que não procediam

Como administrador, quero uma métrica que notifique quantos casos de urgência ocorreram por falta de medicamento no Pyxis e quantos foram por erro do usuário, para orientar melhor o usuário.

#### Critérios de aceitação:

- O aplicativo deve fornecer uma métrica que apresente o número de casos de urgência que ocorreram por falta de medicamento no Pyxis.

- A métrica deve ser atualizada em tempo real ou com uma frequência adequada, refletindo o número atualizado de casos de urgência por falta de medicamento.

- O aplicativo deve fornecer uma métrica separada que apresente o número de casos de urgência que ocorreram por erro do usuário.

- A métrica de erro do usuário também deve ser atualizada em tempo real ou com uma frequência adequada, refletindo o número atualizado de casos de urgência por erro do usuário.

- O aplicativo deve apresentar as duas métricas de forma clara e intuitiva, permitindo ao administrador identificar rapidamente a quantidade de casos em cada categoria.

- O administrador deve poder visualizar as métricas em diferentes períodos de tempo, como por dia, semana, mês ou ano, para analisar tendências ao longo do tempo.

- O aplicativo deve permitir que o administrador clique nas métricas para ver detalhes adicionais, como os casos individuais que compõem cada métrica.

- As métricas devem ser apresentadas de forma que permita ao administrador tomar ações adequadas para orientar melhor os usuários e reduzir os casos de urgência que não procediam.


### 6. Identificação de caso suspeito

Como administrador, quero que os dados do último requisitante antes de uma discrepância nos valores dos medicamentos e os dados dos requisitantes com métricas suspeitas, como um longo tempo de abertura de gaveta, estejam em destaque, para identificar requisições suspeitas e realizar investigações.

#### Critérios de aceitação:

- Para cada caso identificado, o aplicativo deve destacar os dados do último requisitante antes da discrepância, incluindo nome, identificação, data e hora da solicitação, e detalhes da solicitação.

- O aplicativo deve permitir que o administrador acesse facilmente os dados destacados para investigação, clicando em um link ou botão específico.

- Além disso, o aplicativo deve identificar requisitantes com métricas suspeitas, como um tempo de abertura de gaveta muito longo, e destacar seus dados para investigação.

- Os dados dos requisitantes com métricas suspeitas também devem incluir nome, identificação, data e hora da solicitação, e detalhes da solicitação.

- O administrador deve poder visualizar os dados destacados em uma área dedicada do aplicativo, separada das outras visualizações de dados.

- O objetivo dos dados destacados é ajudar o administrador a identificar requisições suspeitas e realizar investigações para evitar fraudes ou erros no sistema.
