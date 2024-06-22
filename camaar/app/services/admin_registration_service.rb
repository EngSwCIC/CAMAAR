class AdminRegistrationService
  def self.call(admin)
    return unless admin.persisted?

    AdminsMailer.new_user_email(admin).deliver_later
  end
end
