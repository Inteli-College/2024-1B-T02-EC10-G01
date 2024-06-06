# Documentação do Aplicativo Mobile Asky

## Visão Geral

O aplicativo Asky é destinado para a solicitação de reabastecimento de medicamentos e materiais em dispensers eletrônicos no Hospital Sírio-Libanês. Ele atende a duas personas principais:

- **Enfermeiros**: Fazem as solicitações de reabastecimento.
- **Auxiliares de Farmácia**: Respondem às solicitações de reabastecimento.

## Funcionalidades Implementadas na Sprint Atual

### Fluxo Principal: Solicitação de Medicamento
Nesta sprint, focamos na implementação e integração do principal fluxo do aplicativo, que é a solicitação de medicamentos. As funcionalidades desenvolvidas incluem:

- **Login com JWT e Roles**: Autenticação de usuários com JSON Web Token (JWT) e definição de roles (enfermeiros e auxiliares de farmácia).
- **Leitura de QR Code do Pyxis**: Para identificar os medicamentos disponíveis nos dispensers eletrônicos.
- **Escolha de Medicamento e Modo de Requisição**: Seleção do medicamento necessário e especificação do modo de requisição.
- **Envio da Requisição com Push Notifications**: Envio de notificações push utilizando Firebase para informar os auxiliares de farmácia sobre novas solicitações.

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento mobile.
- **MobX**: Biblioteca para gerenciamento de estado.
- **Firebase**: Utilizado para envio de notificações push.
- **Ngrok**: Ferramenta para viabilizar a conexão do emulador Android com o backend local durante o desenvolvimento.

## Mudanças no Backend Necessárias Desde a Sprint 2

Para integrar corretamente o aplicativo mobile, foram necessárias as seguintes mudanças no backend:

- **Adicionar Cache com Redis**: Para melhorar a performance e a escalabilidade.
- **Adicionar Tabela de Status para Requisições**: Para monitorar e gerenciar o status das solicitações de reabastecimento.
- **Criar Serviço de Notificações com Chaves de Firebase**: Para enviar notificações push de forma eficiente.

## Estrutura de Arquivos do Projeto

- /lib
- /api: Código relacionado à comunicação com o backend
- /views: Telas do aplicativo
- /widgets
- constants.dart: Constantes utilizadas no aplicativo
- main.dart: Arquivo principal do aplicativo


## Como Rodar o Projeto

1. **Clone o Repositório:**

```bash
   git clone https://github.com/Inteli-College/2024-1B-T02-EC10-G01/tree/main
   cd 2024-1B-T02-EC10-G01
```

2. **Instale as Dependências:**

```bash
flutter pub get
```

3. **Inicie o Backend:**

1. Rode o backend localmente com `docker compose up` na pasta `src/backend`. 
2. Baixe e instale o Ngrok a partir do site oficial, expondo a porta 8000.
3. Atualize a constante `baseUrl` no arquivo `src/mobile/constants.dart`

4. **Rode o aplicativo:**
1. Adicione o arquivo `google-services.json` à pasta `src/mobile`.
2. Conecte um dispositivo Android ao computador ou inicie um emulador.
2. Execute `flutter run`

## Vídeo

<video src='../../static/ video/sprint3.mp4'></video>