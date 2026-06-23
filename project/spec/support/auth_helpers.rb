module AuthHelpers
  def login_as(user, password: "Senha@123")
    post login_path, params: { session: { identifier: user.email, password: } }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers
end
