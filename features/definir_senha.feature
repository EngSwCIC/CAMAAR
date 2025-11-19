# language: pt
#1 ponto
Funcionalidade: Sistema de definição de senha #105
    Eu como Usuário
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
    A fim de acessar o sistema
    
    Contexto:
        Dado que eu cliquei no link de solicitação de cadastro no email "012345678@aluno.unb.br"
        E estou na pagina "definicao senha"

    @105.1
    Cenário: 105.1 - Usuario fornece uma senha valida
        Quando eu preencher o campo "senha" com "password"
        E preencher o campo "confirme a senha" com "password"
        E clicar em "alterar senha"
        Entao devo visualizar a mensagem "Senha definida com sucesso!"
        E sou redirecionado para a pagina de "avaliacoes"

    @105.2
    Cenário: 105.2 - Usuario fornece a confirmacao de senha diferente
        Quando eu preencher o campo "senha" com "password"
        E preencher o campo "confirme a senha" com "passwor"
        E clicar em "alterar senha"
        Entao devo visualizar a mensagem "Confirmação de senha divergente"
    
    @105.3
    Cenário: 105.3 - Usuario nao fornece uma senha
        Dado que os campos "senha" e "confirme a senha" estao vazios
        Quando eu clicar em "alterar senha"
        Entao devo visualizar a mensagem "Forneça uma senha válida"




