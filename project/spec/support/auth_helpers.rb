module AuthHelpers
  def create_department(code: "CIC")
    Department.find_or_create_by!(code:) { |department| department.name = code }
  end

  def create_user(name: "Usuario Teste", email: "user@example.com", registration: "123", role: :participant, password: nil)
    User.create!(
      name:,
      email:,
      registration:,
      role:,
      department: create_department,
      password:
    )
  end

  def create_admin
    create_user(
      name: "Admin CIC",
      email: "admin.cic@unb.br",
      registration: "000000001",
      role: :admin,
      password: "Senha@123"
    )
  end
end

RSpec.configure do |config|
  config.include AuthHelpers
end
