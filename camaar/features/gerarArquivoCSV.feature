# language: pt
Funcionalidade: Gerar relatório do administrador

  Eu como Administrador do sistema CAMAAR
  Quero efetuar o dowloand de um arquivo em CSV contendo os resultados do formulário
  A fim de avaliar o desempenho das turmas cadastradas no sistema

  # FELIZ
  Cenário: Escolher o resultado de um formulário para efetuar o dowloand
    Dado que estou logado no sistema como administrador
    E acesso a pagina resultados dos formulários
    E seleciono um formulário
    Quando clico na opção gerar relatório csv
    Então o arquivo em csv é gerado
    E disponibilizado para dowloand

  # TRISTE
  Cenário: Não escolher um formulário para efetuar o dowloand
    Dado que estou logado no sistema como administrador
    E acesso a pagina resultados dos formulários
    Quando clico na opção gerar relatório csv
    Então um aviso e exibido
    E informa que é necessario selecionar um formulario para gerar o relatório em CSV