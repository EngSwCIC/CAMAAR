require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "new_user_email" do
    mail = UserMailer.new_user_email
    assert_equal "New user email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
