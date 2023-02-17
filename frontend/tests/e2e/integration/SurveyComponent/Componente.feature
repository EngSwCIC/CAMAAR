#language: pt
Funcionalidade: Adicionar e remover componentes de questionário

  Cenário: Adicionar um componente de texto
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    Então eu devo ver o componente de texto

  Cenário: Adicionar um título na pergunta
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu preencher o campo de Pergunta sem título com "Título legal"
    Então o título da pergunta deve ser "Título legal"

  Cenário: Campo de resposta desabilitado
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    Então eu devo ver o campo "texto da resposta" desabilitado


  Cenário: Adicionar um componente de caixa de seleção
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Caixa de seleção"
    Então eu devo ver o componente de caixa de seleção

  Cenário: Campo de resposta desabilitado
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Caixa de seleção"
    Então eu devo ver o campo checkbox desabilitado

  Cenário: Colocar um texto na resposta
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Caixa de seleção"
    E eu preencher o campo de texto com "Abacate"
    Então o campo de resposta deve ser "Abacate"

  Cenário: Adicionar linha da caixa de seleção
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Caixa de seleção"
    E eu clicar no botão "Adicionar linha"
    Então eu devo ver duas linhas

  Cenário: Remover linha da caixa de seleção
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Caixa de seleção"
    E eu clicar no botão "Adicionar linha"
    E eu clicar no botão "Adicionar linha"
    E eu clicar no botão "Adicionar linha"
    E eu clicar no botão "x"
    Então eu devo ver três linhas

  Cenário: Adicionar um componente de múltipla escolha
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Múltipla escolha"
    Então eu devo ver o componente de múltipla escolha

  Cenário: Campo de resposta desabilitado
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Múltipla escolha"
    Então eu devo ver o campo radio desabilitado

  Cenário: Colocar um texto na resposta
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Múltipla escolha"
    E eu preencher o campo de resposta com "Abacate"
    Então o campo de resposta deve ser "Abacate"

  Cenário: Adicionar linha da múltipla escolha
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Múltipla escolha"
    E eu clicar no botão "Adicionar linha"
    Então eu devo ver duas linhas

  Cenário: Remover linha da caixa de seleção
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Múltipla escolha"
    E eu clicar no botão "Adicionar linha"
    E eu clicar no botão "Adicionar linha"
    E eu clicar no botão "Adicionar linha"
    E eu clicar no botão "x"
    Então eu devo ver três linhas

  Cenário: Adicionar um componente de escala linear
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Escala linear"
    Então eu devo ver o componente de escala linear

  Cenário: Mudar o valor inicial
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Escala linear"
    E eu clicar no botão "0"
    E eu clicar no botão "1"
    Então o valor inicial deve ser 1

  Cenário: Mudar o valor final
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Escala linear"
    E eu clicar no botão "5"
    E eu clicar no botão "10"
    Então o valor final deve ser 10

  Cenário: Colocar um marcador inicial
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Escala linear"
    E eu preencher o campo "Marcador Inicial" com "Ruim"
    Então o marcador inicial deve ser "Ruim"

  Cenário: Colocar um marcador final
    Dado que eu estou na rota "/surveys"
    E eu clicar no botão "adicionar"
    E eu clicar no botão "Texto"
    E eu clicar no botão "Escala linear"
    E eu preencher o campo "Marcador Final" com "Maneiro"
    Então o marcador inicial deve ser "Maneiro"

