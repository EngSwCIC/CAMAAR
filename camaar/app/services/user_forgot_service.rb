class UserForgotService
  def self.call(user)
    return unless user.persisted?

    UserMailer.user_forgot_email(user).deliver_later
  end
end
