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

Given(/^(?:I am |There is )?a valid user(?: on the system)?$/) do
  email = 'vanessa@gmail.com'
  password = '$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu' # TOKEN_587
  salt = '$2a$12$9sauXRcV/alggmsRweudU.'
  created_at = Time.now
  is_admin = false

  @user = User.new
  @user.email = email
  @user.salt = salt
  @user.password = password
  @user.created_at = created_at
  @user.is_admin = is_admin
  @user.save!
end
