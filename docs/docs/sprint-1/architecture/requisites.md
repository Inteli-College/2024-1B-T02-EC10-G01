---
title: Requisitos funcionais e não funcionais
sidebar_position: 2
---
## Requisitos Funcionais:

Os requisitos funcionais descrevem as funcionalidades específicas que um sistema deve fornecer. Eles descrevem o que o sistema deve fazer em termos de operações, serviços ou funções. 

| Requisito | Descrição | Resultado esperado |
|-----------|-----------|-------------------|
| Autenticação de Usuários | Os usuários devem poder fazer login na plataforma usando credenciais válidas. | Acesso seguro à plataforma para usuários autorizados. |
| Envio de Requisições | Os colaboradores devem poder enviar requisições de medicamentos através do aplicativo móvel. As requisições devem incluir detalhes como o medicamento solicitado, a quantidade necessária e a localização do dispensador. | Processo eficiente de requisição de medicamentos por meio do aplicativo móvel. |
| Controle de Acesso | Os operadores do sistema devem ter a capacidade de modificar as permissões de acesso dos usuários. Certos medicamentos, especialmente os controlados, devem ter permissões especiais de acesso. | Gerenciamento flexível e granular de permissões de acesso, garantindo segurança e conformidade. |
| Rastreabilidade de Medicamentos | O sistema deve permitir o rastreamento completo dos medicamentos desde o pedido até o uso final. Cada transação relacionada aos medicamentos deve ser registrada e disponível para consulta. | Rastreamento preciso e documentação completa das transações de medicamentos para fins de auditoria e conformidade. |
| Integração com Outros Sistemas | Deve haver uma API para integração com sistemas existentes no hospital, como sistemas de estoque e de registros médicos. | Integração perfeita com sistemas hospitalares existentes, permitindo a troca de dados de forma eficiente. |
| Geração de Relatórios | O sistema deve ser capaz de gerar relatórios sobre os medicamentos utilizados, as requisições feitas e outros dados relevantes. | Geração automática de relatórios detalhados para análise e tomada de decisões informadas. |
| Monitoramento da Aplicação | Deve ser implementado um sistema de monitoramento de saúde da aplicação para identificar e resolver problemas de desempenho e estabilidade. | Identificação proativa e resolução de problemas de desempenho e estabilidade da aplicação. |

## Requisitos Não Funcionais:

Os requisitos não funcionais descrevem atributos do sistema que não estão diretamente relacionados às funcionalidades específicas, mas são igualmente importantes para a sua qualidade e desempenho.

| Requisito | Descrição | Resultado esperado |
|-----------|-----------|-------------------|
| Segurança | O sistema deve garantir a segurança dos dados dos pacientes e das transações de medicamentos, seguindo as melhores práticas de segurança, como criptografia de dados e controle de acesso. | Proteção confiável dos dados sensíveis e conformidade com regulamentações de segurança. |
| Desempenho | O sistema deve ser capaz de lidar com um grande volume de requisições sem comprometer o desempenho, garantindo um tempo de resposta rápido. | Resposta rápida e consistente às requisições, mesmo em momentos de alta demanda. |
| Escalabilidade | O backend deve ser escalável para lidar com o crescimento futuro do número de usuários e requisições, permitindo adicionar recursos facilmente conforme necessário. | Capacidade de expansão do sistema para acompanhar o crescimento da demanda sem comprometer a qualidade do serviço. |
| Compatibilidade com Dispositivos Móveis | O aplicativo móvel deve ser compatível com uma variedade de dispositivos Android, garantindo uma boa experiência do usuário em diferentes telas e tamanhos. | Experiência consistente e intuitiva para os usuários, independentemente do dispositivo móvel utilizado. |
| Usabilidade | A interface do aplicativo móvel deve ser intuitiva e fácil de usar, mesmo para usuários não técnicos. O sistema deve fornecer feedback claro sobre o status das requisições e a disponibilidade dos medicamentos. | Experiência do usuário otimizada, com interface intuitiva e feedback informativo em tempo real. |
| Disponibilidade | O sistema deve estar disponível 24/7, garantindo que os colaboradores possam fazer requisições a qualquer momento, conforme necessário. | Acesso ininterrupto ao sistema para garantir a disponibilidade contínua dos serviços de requisição de medicamentos. |
| Manutenção | O sistema deve ser fácil de manter e atualizar, com mínima interrupção para os usuários finais. As atualizações devem ser aplicadas de forma transparente, sem afetar a operação contínua do sistema. | Manutenção eficiente e atualizações transparentes para garantir a operação contínua e aprimoramentos regulares do sistema. |
