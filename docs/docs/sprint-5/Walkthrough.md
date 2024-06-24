---
title: Introdução
slug: /sprint-5
---

# Walkthrough da aplicação

## Vídeo 

<iframe width="560" height="315" src="https://www.youtube.com/watch?v=NH4VseyHHxc" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

 
## Objetivo

O objetivo de aplicativo é otimizar o processo de abrir chamados feitos por enfermeiros para auxiliares de farmácia. No dia a dia do hospital, os enfermeiros precisam acessar um dispenser de remédios, que, por vezes, por ter remédios faltando, uma porta da máquina pode emperrar ou um equipamento lá dentro esteja em falta.

Atualmente, os enfermeiros necessitam ligar para os auxiliares de farmácia, que não tem controle das demandas, para solicitar um medicamento, uma material ou assistência. Após isso, o auxilar precisa se apressar para cumprir a solicitação quanto antes.

O problema nesse fluxo é que há gargalo para o enfermeiro e uma falta de planejamento para o auxiliar. De modo que as entregas atrasem e acumulem.

## Fluxo

### Enfermeiro

Ao entrar no aplicativo, o enfermeiro realiza o login e logo já se depara com a tela inicial, onde ele pode criar uma nova solicitação, acompanhar a última solicitação, verificar o histórico de solicitações ou acessar o seu perfil. Como o objetivo principal do enfermeiro é criar novas solicitações, o botão de novas solicitações é centralizado e está em destaque.

Após clicar em solicitar algo, o aplicativo automaticamente abre a câmera do usuário. Basta agora, apenas apontar a câmera para o QR Code presente no pyxis. No caso do vídeo demonstrado, ele foi realizado em um simulador, por isso ao abrir a câmera, o aplicativo simula um espaço 3D, onde é possível escanear um QR Code, referente ao dispenser que o enfermeiro se encontra.

Com o pyxis localizado, o usuário pode escolher entre pedir um medicamento, um material ou assistência. No primeiro, é possível diferenciar o remédio solicitado com uma emergência ou não. Já no último, há como adicionar um feedback, indicando com mais detalhes qual a assistência necessária.

Finalmente, uma vez que a solicitação foi feita, ela se encaminha para o auxiliar, que pode atualizar o status do pedido, de acordo com que etapa do processo ele está. Essas mudanças ficam visíveis na página histórico, junto com os detalhes de todas as requisições feitas.

### Auxiliar

Para o auxiliar o fluxo é mais enxuto, uma vez que o objetivo principal é ter controle das solicitações e aprová-las. Ao entrar no aplicativo, sua página principal já contém todos as solicitações que foram feitas. Para aceitar esses pedidos, basta clicar no card, e alterar o status de acordo com o drop-down menu que aparece logo abaixo da barra de progressão de status.


## Como rodar o Front-End da aplicação.

Como o serviço foi desenvolvido em Flutter, não é possível criar um contîner dessa parte da aplicação, o que facilitaria executar, mas uma vez que ele for processado, ele fica salvo no sistema.

Primeiramente é necessário baixar ambos o **VS Code** e **Flutter**:
- [VS Code](https://code.visualstudio.com/download)
- [Flutter](https://docs.flutter.dev/get-started/install?gad_source=1&gclid=Cj0KCQjwj9-zBhDyARIsAERjds3ro5ekXN0EgrBqZ_VL--nQjF6yVdEP-T5-d2kIxaLQ0Vljj9kHjmgaAgBjEALw_wcB&gclsrc=aw.ds)

Em segundo, para executar é necessário rodar o ngrok, a fim de ter um endpoint para rodar a aplicação. Mas primeiro, é necessário ter o Back-End da aplicação rodando, o que está disponível em outra documentação desta sprint. Para isso deve-se realizar:

```
ngrok http http://localhost:8000
```

E substituir a variável ***baseUrl***, no arquivo *`src/mobile/lib/constants.dart`* por este valor correspondente ao campo ***Forwaing***

![ngrok](docs/static/img/ngrok.png)


Após isso, basta conectar o celular ao dispositivo que estára executando a aplicação e selecionar no canto da tela, o campo ***No Device***

![no-device](docs/static/img/no-device.png)

E depois selecionar o seu dispositivo para rodar a aplicação! (Os dispositivos demonstrados abaixos são apenas parte do Android Studio, um simulador de smartphones Android)

![choose-device](docs/static/img/choose-device.png)
