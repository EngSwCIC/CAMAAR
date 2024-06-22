module UserStepHelper
    def create_user(params)
      user = User.new(params)
      user.skip_confirmation_notification!
      user.confirm
      user.save
      user
    end
end

World(UserStepHelper)

    Given(/^"([^"]*)" with login "([^"]*)" and password "([^"]*)" exists$/) do |nome, email, password|
    # Cria um usuário com email, senha e nome
    create_user({
        :nome => nome, 
        :email => email, 
        :password => password, 
        :password_confirmation => password,
        :usuario => email
    })
    end

    Given(/^I am logged out$/) do
    # Dá logout no current user indo para o path de destroir a sessão
    visit destroy_user_session_path
    end

    Given(/^I am on the login page$/) do
    # Visita a página
    visit root_path
    end

    When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
    fill_in field, with: value
    end

    When(/^I press "([^"]*)"$/) do |button|
    # Click the button
    click_button button
    end

    Then('I should see {string}') do |string|
        expect(page).to have_content string
    end

    Then(/^I should not be logged in$/) do
        visit root_path
        expect(page).to have_content "login"
    end

    Then(/^I should be logged in$/) do
        visit root_path
        expect(page).to have_content "Deslogar"
    end