class PasswordMailer < ApplicationMailer
  def reset
      @token = params [:user].signed_id(purpose: "change_password")

      mail to: params[:user].email
  end
end
