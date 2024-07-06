    
    Given('the student {string} with email {string} is participant of a SIGAA class') do |nome, email|
        User.delete_all
        @sigaa = 
        {
            "dicente": 
            [
                {
                    "nome": nome,
                    "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                    "matricula": "123456789",
                    "usuario": "123456789",
                    "formacao": "graduando",
                    "ocupacao": "discente",
                    "email": email
                },
                {
                    "nome": "Ciclano",
                    "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                    "matricula": "24681012",
                    "usuario": "24681012",
                    "formacao": "graduando",
                    "ocupacao": "discente",
                    "email": "ciclano@gmail.com"
                }
            ]
        }
    end

    Given('{string} was not already registred') do |email|
    end

    When('I import data from SIGAA') do
        discentes = @sigaa[:dicente]

        for dicente in discentes do
            if (!User.exists?(email: dicente[:email]))
                user = create_user(
                    nome: dicente[:nome], 
                    password: "senha_padrao", 
                    curso: dicente[:curso],
                    matricula: dicente[:matricula], 
                    usuario: dicente[:matricula],
                    formacao: dicente[:formacao], 
                    ocupacao: dicente[:ocupacao],
                    email: dicente[:email]
                )
                user.send_reset_password_instructions
            end
        end
    end

    Given('{string} was already registred with email {string} and password {string} exists') do |nome, email, senha|
        user = create_user({
            nome: nome,
            email: email,
            password: senha,
            password_confirmation: senha,
            usuario: "123546789"
        })
        user.confirm
    end

    Then('an email shoud not be sent to {string} containing a link') do |email|
        expect(ActionMailer::Base.deliveries.count).to eq(1)
    end