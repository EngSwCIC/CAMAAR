# language: pt

Funcionalidade: Criação de formulário para docentes ou discentes
    Eu como Administrador
    Quero escolher criar um formulário para os docentes ou os discentes de uma turma
    A fim de avaliar o desempenho de uma matéria

    Contexto:
        Dado que existe um administrador logado no CAMAAR
        E o semestre letivo atual está configurado
        E existe a turma "Engenharia de Software" com 1 docente e 40 discentes vinculados

    @cenario_feliz
    Cenário: Criar formulário de avaliação direcionado aos discentes (Caminho Feliz)
        Dado que o administrador acessa a página de criação de formulário para a turma "Engenharia de Software"
        Quando ele preenche os dados do formulário com o título "Avaliação da Matéria pelos Alunos"
        E seleciona o público-alvo como "Discentes"
        E clica em "Salvar e Publicar"
        Então o sistema deve registrar o formulário com sucesso
        E o formulário deve ficar disponível apenas no painel dos alunos (discentes) matriculados nesta turma
        E o sistema não deve permitir que o docente da turma responda a este formulário

    @cenario_feliz
    Cenário: Criar formulário de autoavaliação direcionado aos docentes (Caminho Feliz)
        Dado que o administrador acessa a página de criação de formulário para a turma "Engenharia de Software"
        Quando ele preenche os dados do formulário com o título "Relatório de Desempenho da Matéria"
        E seleciona o público-alvo como "Docentes"
        E clica em "Salvar e Publicar"
        Então o sistema deve registrar o formulário com sucesso
        E o formulário deve ficar disponível exclusivamente no painel do professor responsável pela turma
        E o sistema não deve notificar ou exibir o formulário para os alunos

    @cenario_triste
    Cenário: Tentar criar um formulário sem definir o público-alvo (Caminho Triste)
        Dado que o administrador inicia a criação de um novo formulário para uma turma
        Quando ele preenche todas as perguntas da avaliação
        Mas deixa o campo de seleção "Público-alvo" em branco
        E tenta clicar em "Salvar e Publicar"
        Então a validação do formulário deve falhar
        E o sistema deve exibir a mensagem de erro "Obrigatório: Selecione se o formulário é destinado a docentes ou discentes."

    @cenario_triste
    Cenário: Tentar criar formulário para discentes em uma turma vazia (Caminho Triste)
        Dado que a turma "Tópicos Avançados" foi recém-criada e ainda não possui alunos (discentes) matriculados
        Quando o administrador tenta criar um formulário selecionando o público-alvo como "Discentes" para esta turma
        E clica em "Salvar e Publicar"
        Então a criação deve ser bloqueada
        E o sistema deve exibir o alerta "Ação inválida: Esta turma ainda não possui discentes vinculados no SIGAA para responderem à avaliação."

    @cenario_triste
    Cenário: Tentativa de sobreposição de formulário para o mesmo público (Caminho Triste)
        Dado que a turma "Engenharia de Software" já possui um formulário ativo direcionado aos "Discentes"
        Quando o administrador tenta criar uma nova avaliação e seleciona novamente "Discentes" como público-alvo
        Então o sistema deve interceptar a ação
        E exibir a mensagem de aviso "Atenção: Já existe um formulário ativo para os discentes desta turma. Encerre o atual antes de publicar um novo."