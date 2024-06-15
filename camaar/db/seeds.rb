# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

create(:user, nome: "Admin User", email: "admin@example.com",
curso: "CIÊNCIA DA COMPUTAÇÃO/CIC",matricula: "190084006", formacao: "doutorado", ocupacao: "docente",
password: "123456789", role: :admin, password_confirmation: "123456789",
reset_password_token: nil,
reset_password_sent_at: nil, remember_created_at: nil)
create(:user, nome: "User", email: "user@example.com",
curso: "CIÊNCIA DA COMPUTAÇÃO/CIC",
matricula: "190085006", formacao: "graduando", ocupacao: "dicente",
password: "123456789",role: :user,
password_confirmation: "123456789", reset_password_token: nil,
reset_password_sent_at: nil, remember_created_at: nil)
