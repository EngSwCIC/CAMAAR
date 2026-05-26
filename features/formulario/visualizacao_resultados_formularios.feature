# language: pt
Funcionalidade: (#110) Visualização de resultados dos formulários
  Como um Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Cenário: Visualizar consolidação de respostas quantitativas e qualitativas (Caminho Feliz)
    Dado que estou logado com o "perfil" de "administrador"
    E existe um "formularios" que recebeu registros na tabela "respostas"
    E esses registros possuem dados na tabela "resposta_itens" contendo valores preenchidos em "valor_numerico" e "valor_texto"
    Quando eu acesso o painel interno de métricas do formulário
    Então a aplicação deve realizar o agrupamento das questões e exibir as médias calculadas a partir do "valor_numerico"

  Cenário: Usuário sem privilégios administrativos tenta burlar acesso ao painel (Caminho Triste - Controle de Acesso)
    Dado que estou autenticado no sistema como um "usuarios" com "perfil" "discente"
    Quando eu tento acessar diretamente a URL restrita de resultados de um "formularios"
    Então o sistema deve interceptar a rota, impedir a renderização da página
    E redirecionar-me para a página inicial com o alerta "Acesso negado: Perfil não autorizado"

  Cenário: Painel de resultados de formulário sem nenhuma submissão (Caminho Triste - Sem Dados)
    Dado que um "formularios" foi criado recentemente e a tabela "respostas" possui zero registros vinculados a ele
    Quando o administrador clica no painel de acompanhamento deste formulário específico
    Então o sistema deve carregar a view com sucesso, mas apresentar o aviso estrutural "Este formulário ainda não recebeu respostas"