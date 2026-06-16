# language: pt

Funcionalidade: Criar template de formulário
  Como um Administrador
  Eu quero criar um novo template com questões predefinidas
  A fim de padronizar os formulários de avaliação

  Cenário: Criação de template com sucesso (Caminho Feliz)
    Dado que eu estou logado como "Administrador"
    E acesso a página de "Novo Template"
    Quando eu preencho o campo "Nome do Template" com "Avaliação Padrão"
    E adiciono questões de múltipla escolha e texto
    E clico em "Salvar Template"
    Então o sistema deve salvar o template no banco de dados
    E o sistema exibe a mensagem "Template criado com sucesso"

  Cenário: Criação de template sem título (Caminho Triste)
    Dado que eu estou logado como "Administrador"
    E acesso a página de "Novo Template"
    Quando eu deixo o campo "Nome do Template" em branco
    E adiciono questões de múltipla escolha
    E clico em "Salvar Template"
    Então o sistema não deve salvar o template
    E exibe a mensagem de erro "O nome do template é obrigatório"
