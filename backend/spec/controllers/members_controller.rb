require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe MembersController, type: :controller do
  describe 'GET #redefine_password' do
    context 'when the redefinition_link is valid' do
      # This member has to be created to this test to work
      role_discente = Role.create(name: 'discente', description: 'discente')
      member = Member.new(
        email: 'email@correto',
        name: 'name',
        course: 'course',
        registration: '123',
        username: '123',
        degree: 'graduação',
        role: role_discente,
        redefinition_link: 'link_correto_de_redefinicao_de_senha'
      )

      before do
        get :redefine_password, params: { redefinition_link: 'link_correto_de_redefinicao_de_senha' }
      end

      it 'responds with a JSON object indicating success' do
        expect(response).to have_http_status(:ok)
        expect_body = JSON.parse(response.body)

        expect(expect_body['name']).to eq(member.name)
        expect(expect_body['email']).to eq(member.email)
        expect(expect_body['course']).to eq(member.course)
        expect(expect_body['registration']).to eq(member.registration)
        expect(expect_body['username']).to eq(member.username)
        expect(expect_body['degree']).to eq(member.degree)
        expect(expect_body['redefinition_link']).to eq(member.redefinition_link)
      end
    end
  end
end
