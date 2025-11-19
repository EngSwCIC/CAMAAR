Funcionalidade: Criação de formulário para docentes ou dicentes

Cenário: Enviar formulário para Discentes de uma turma específica (Feliz)
    Dado que estou criando um novo formulário a partir de um template
    Quando seleciono a opção "Discentes" no campo de público-alvo
    E seleciono uma turma válida "Turma A - Engenharia"
    E clico no botão "Enviar"
    Então o formulário deve ser enviado especificamente para os alunos daquela turma

Cenário: Enviar formulário para Docentes (Feliz)
    Dado que estou criando um novo formulário
    Quando seleciono a opção "Docentes" no campo de público-alvo
    Então o formulário deve ser enviado especificamente para os professores
    E o campo de seleção de turma deve ficar oculto ou opcional

Cenário: Tentativa de criar sem selecionar público (Triste)
    Dado que preenchi os dados básicos do formulário
    E não selecionei nem "Docente" nem "Discente"
    Quando tento clicar em "Enviar"
    Então o sistema deve exibir o erro "Selecione o público-alvo da avaliação"
    E não deve enviar o formulário
