class AdminRegistrationService
  def self.call(admin)
    return unless admin.persisted?

    AdminMailer.new_user_email(admin).deliver_later
  end
end
