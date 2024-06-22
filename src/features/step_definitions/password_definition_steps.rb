
Given('{string} with login {string} and password {string} solicitates password redefinition') do |nome, email, senha|
        user = create_user({
            nome: nome,
            email: email,
            password: senha,
            password_confirmation: senha,
            usuario: email
        })
        user.send_reset_password_instructions
        open_email(email)
        current_email.click_link "Definir Senha"
    end
    
    Given('recieved an email with a link for registration in the system') do
        pending # Write code here that turns the phrase above into concrete actions
    end
    
    When('login with "{string}" and "{string2}"') do |string, string2|
        Given('I am logged out')
        Given('I am on the login page')
        When('I fill in "E-mail" with "{string}"')
        When('I fill in "Senha" with "{string2}"')
        When('I press "Entrar"')
        Then('I should be logged in')
    end