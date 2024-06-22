
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
    
    When('I login with {string} and {string}') do |string, string2|
        visit destroy_user_session_path
        visit root_path
        fill_in "E-mail", with: string
        fill_in "Senha", with: string2
        click_button "Entrar"
    end