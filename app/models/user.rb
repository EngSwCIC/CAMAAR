class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registrable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  attr_writer :login

  def login
    @login || self.matricula || self.email
  end
end
