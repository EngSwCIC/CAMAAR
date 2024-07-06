require 'capybara/email/rspec'

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/'
end

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|

    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|

    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end


def user_refresh
  @user = User.find_by_email(@user.email)
end

def cria_usuario
  User.delete_all
  @user = User.new(
    nome: "Fulano", 
    email: "teste@email.com", 
    curso: "CIÊNCIA DA COMPUTAÇÃO/CIC", 
    matricula: "123456789", 
    usuario: "123456789", 
    formacao: "graduando", 
    ocupacao: "discente", 
    password: "password", 
    password_confirmation: "password"
  )
  @user.skip_confirmation_notification!
  expect(@user.save).to be true
end