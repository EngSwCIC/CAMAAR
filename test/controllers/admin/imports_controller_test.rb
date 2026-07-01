require "test_helper"

class Admin::ImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(
      email: "admin_test@example.com",
      matricula: "admin999",
      password: "password123",
      password_confirmation: "password123",
      role: "admin"
    )
    post login_url, params: { login: @admin.email, password: "password123" }
  end

  test "should get index" do
    get admin_imports_url
    assert_response :success
  end

  test "should create import members" do
    # Create required classes first
    d = Disciplina.create!(code: 'CIC0097', name: 'BANCO DE DADOS')
    Turma.create!(classCode: 'TA', semester: '2021.2', disciplina: d)

    file = fixture_file_upload('class_members.json', 'application/json')
    
    # Just check if it increases and notice message is correct
    assert_difference('User.count', 45) do 
      post admin_imports_url, params: { file: file, import_type: 'members' }
    end

    assert_redirected_to admin_imports_url
    assert_equal 'Participantes importados com sucesso', flash[:notice]
    
    # Check if a specific user was invited
    user = User.find_by(matricula: '190084006')
    assert_not_nil user
    assert_not_nil user.invitation_token
    assert_nil user.password_digest
  end
end
