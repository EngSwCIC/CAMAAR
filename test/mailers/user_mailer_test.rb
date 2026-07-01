require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "invitation" do
    mail = UserMailer.invitation
    assert_equal "Invitation", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
