class UserRegistrationService
  def self.call(user)
    if user.persisted?
      UserMailer.new_user_email(user).deliver_later
    end
  end
end
