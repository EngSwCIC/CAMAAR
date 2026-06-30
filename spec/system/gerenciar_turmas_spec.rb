require 'rails_helper'

RSpec.describe "Gerenciamento de Turmas por Departamento", type: :system do
  before do
    driven_by(:rack_test)

    @admin = User.create!(
      nome: "Admin CIC",
      matricula: "000000001",
      email: "admin_cic@camaar.com",
      password: "password123",
      perfil: "docente",
      departamento: "CIC"
    )

    @turma_cic = Turma.create!(
      code: "CIC0105",
      class_code: "TA",
      semester: "2021.2",
      name: "ENGENHARIA DE SOFTWARE",
      departamento: "CIC"
    )

    @turma_mat = Turma.create!(
      code: "MAT0101",
      class_code: "UA",
      semester: "2021.2",
      name: "CÁLCULO 1",
      departamento: "MAT"
    )
  end

  it "permite que o administrador veja apenas as turmas do seu departamento" do
    visit new_user_session_path
    fill_in "Email", with: @admin.email
    fill_in "Password", with: @admin.password
    click_button "Log in"

    visit turmas_path

    expect(page).to have_text("ENGENHARIA DE SOFTWARE")
    expect(page).to have_text("CIC0105")

    expect(page).not_to have_text("CÁLCULO 1")
    expect(page).not_to have_text("MAT0101")
  end

  it "garante que o administrador não visualize turmas de outros departamentos na URL" do
    visit new_user_session_path
    fill_in "Email", with: @admin.email
    fill_in "Password", with: @admin.password
    click_button "Log in"

    visit turmas_path

    expect(page).to have_text("CIC0105")
    
    expect(page).not_to have_text("CÁLCULO 1")
    expect(page).not_to have_text("MAT0101")
  end
end
