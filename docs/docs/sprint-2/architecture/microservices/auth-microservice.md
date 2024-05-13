# Microsserviço de Autenticação

O microsserviço de autenticação é responsável por gerenciar as contas dos usuários e fazer a devida proteção da aplicação de acessos mal intencionados de pessoas externas a organização através de tokens e outros sistemas, que não possuam/deveriam possuir contas ou quaisquer tipos de acesso ao sistema.

## Por que é necessário?

Além da necessidade do sistema de autenticação que já foi explicada no parágrafo anterior, o microsserviço de autenticação é uma das partes mais importantes da nossa aplicação. A sua principal funcionalidade além dessa orquestração, é a comunicação entre outros microsserviços, sendo responsável principalmente pela entrega dos dados do usuário a outras áreas da aplicação para realizar a atribuição e a identificação a tarefas e ações especificas.