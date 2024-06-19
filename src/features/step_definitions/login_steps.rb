
    Given(/^"([^"]*)" with login "([^"]*)" and password "([^"]*)" exists$/) do |nome, email, password|
    # Cria um usuário com email, senha e nome
    RegistrationsController.create
    
    end

    Given(/^I am logged out$/) do
    # Dá logout no current user indo para o path de destroir a sessão
    visit destroy_user_session_path
    end

    Given(/^I am on the login page$/) do
    # Visita a página
    visit new_session_path
    end

    When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
    fill_in field, with: value
    end

    When(/^I press "([^"]*)"$/) do |button|
    # Click the button
    click_button button
    end

    Then(/^I should see "([^"]*)"$/) do |message|
    # Verifica se a mensagem tem a mensagem
    expect(page).to have_content message
    end