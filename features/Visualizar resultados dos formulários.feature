Funcionalidade: Visualizar resultados dos formulários
  Como administrador ou coordenador
  Quero visualizar os resultados dos formulários enviados aos discentes
  Para acompanhar as respostas e gerar análises a partir dos dados coletados

  @feliz
  Cenário: Visualizar resultados enquanto formulário ainda está aberto
  Dado que o formulário "Avaliação 2025" ainda está em periodo de resposta
  E que já existem algumas submissões
  Quando clico em "Visualizar Resultados"
  Então vejo as respostas parciais com um aviso de que o formulário ainda está ativo

  @feliz
  Cenário: Visualizar resultados com sucesso
  Dado que estou logado como administrador
  E que há um formulário publicado com respostas coletadas
  Quando acesso a aba "Resultados"
  Então devo ver a listagem das respostas vinculadas ao formulário
  E consigo visualizar os dados por pergunta ou por respondente

  @triste
  Cenário: Tentar acessar formulário de outro curso
  Dado que estou logado como coordenador do curso de Engenharia
  E que o formulário pertence aо curso de Direito
  Quando tento acessar a visualização dos resultados
  Então recebo uma mensagem de erro: "Acesso negado formulário não pertence ao seu curso"
