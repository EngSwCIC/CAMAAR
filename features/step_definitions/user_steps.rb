Given(/^(?:I am |There is )?a valid administrator(?: on the system)?$/) do
  email = 'coordenador@gmail.com'
  password = '$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu' # TOKEN_587
  salt = '$2a$12$9sauXRcV/alggmsRweudU.'
  created_at = Time.now
  is_admin = true

  @user = User.new
  @user.email = email
  @user.salt = salt
  @user.password = password
  @user.created_at = created_at
  @user.is_admin = is_admin
  @user.save!
end

Given(/^(?:I )?login with @credentials$/) do
  visit login_path
  fill_in :email, with: @credentials[:email]
  fill_in :password, with: @credentials[:password]
  click_button 'Entrar'
end

Given(/^(?:I am )?logged in as an administrator$/) do
  step 'a valid administrator'

  @credentials = {
    email: 'coordenador@gmail.com',
    password: 'TOKEN_587'
  }
  step 'I login with @credentials'
end
