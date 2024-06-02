class UserRegistrationService
  def self.call(user)
    return unless user.persisted?

    UserMailer.new_user_email(user).deliver_later
  end
end
