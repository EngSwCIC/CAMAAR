# language: pt

Funcionalidade: Cadastrar usuários do sistema
    Como Administrador
    Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos para o sistema
    A fim de que eles acessem o sistema CAMAAR

    Contexto:
        Dado que estou logado como Administrador de teste
        E estou na página de "Gerenciamento - Usuários"

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Solicitação de definição de senha para novo usuário importado
        Dado que importei o arquivo "class_members.json"
        E o sistema identificou the novo usuário with matrícula "190084006"
        Quando o usuário "190084006" acessa a página de login
        E preencho o campo de cadastro "Email ou Matrícula" com "190084006"
        E deixo o campo de cadastro "Senha" em branco
        E clico no botão de cadastro "Entrar"
        Então sou redirecionado para a página de cadastro "Definição de Senha"
        E vejo a mensagem de cadastro "Este é seu primeiro acesso. Por favor, defina uma senha."

    Cenário: Efetivação do cadastro após definição de senha
        Dado que o usuário "190084006" está na página "Definição de Senha"
        Quando preencho o campo de cadastro "Nova Senha" com "senhaSegura123"
        E preencho o campo de cadastro "Confirmar Senha" com "senhaSegura123"
        E clico no botão de cadastro "Definir Senha"
        Então sou redirecionado para a página de cadastro "painel principal"
        E vejo a mensagem de sucesso de cadastro "Cadastro efetivado com sucesso!"
        E meu status no sistema passa a ser "Ativo"

    # ==================== CENÁRIOS TRISTES ====================
    Cenário: Tentativa de definição de senha com campos divergentes
        Dado que o usuário "190084006" está na página "Definição de Senha"
        Quando preencho o campo de cadastro "Nova Senha" com "senha123"
        E preencho o campo de cadastro "Confirmar Senha" com "senha456"
        E clico no botão de cadastro "Definir Senha"
        Então permaneço na página de cadastro "Definição de Senha"
        E vejo a mensagem de erro de cadastro "As senhas não coincidem"

    Cenário: Tentativa de definição de senha muito curta
        Dado que o usuário "190084006" está na página "Definição de Senha"
        Quando preencho o campo de cadastro "Nova Senha" com "123"
        E preencho o campo de cadastro "Confirmar Senha" com "123"
        E clico no botão de cadastro "Definir Senha"
        Então permaneço na página de cadastro "Definição de Senha"
        E vejo a mensagem de erro de cadastro "A senha deve ter no mínimo 8 caracteres"


    Cenário: Tentativa de acesso sem definir senha após importação
        Dado que o usuário "190084006" foi importado mas não definiu senha
        Quando tento acessar a página "Avaliações" diretamente
        Então sou redirecionado para a página de cadastro "Definição de Senha"
        E vejo o alerta de cadastro "Este é seu primeiro acesso. Por favor, defina uma senha."

