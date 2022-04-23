class UsersController < ApplicationController
    def create
      created_at = params[:created_at_pessoa]
      updated_at = params[:updated_at_pessoa]
      email = params[:email_pessoa]
      senha = User.new(:password => params[:senha_pessoa]).encrypted_password
        if Member.exists?(:email=> email)
          unless User.exists?(:email=> email.downcase)
            member = Member.find_by(:email => email)
            user = User.create(email: email,encrypted_password: senha, created_at: created_at, updated_at: updated_at , member: member)
        end
      end
      render json: {
        user: user,
      }, status: :ok
    end

  end
