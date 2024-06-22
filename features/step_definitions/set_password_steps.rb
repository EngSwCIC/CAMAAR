Given /^I have a reset password token$/ do
  @token = @user.send(:set_reset_password_token)
end