require 'rails_helper'
RSpec.describe TemplateQuestionsController, type: :controller do
  let(:admin) { create(:admin, :admin1) }
  @controller = TemplateQuestionsController.new
  before do
    allow(controller).to receive(:authenticate_admin!).and_return(true)
    allow(controller).to receive(:current_admin).and_return(admin)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  it 'allows to access :new template question route' do
    departament = create(:department, :departament1)
    coordinator = create(:coordinator, :coordinator1)
    template = create(:template, :template1)

    sign_in admin
    # DELETE /admins/templates/:template_id/template_questions/:id(.:format)    template_questions#destroy
    get :new, params: { template_id: template.id, id: 1 }
    # expect(response).to redirect_to(new_template_template_question_path(template))
    expect(response).to have_http_status(:ok)
  end

  it 'allows to access :destroy template question route' do
    departament = create(:department, :departament1)
    coordinator = create(:coordinator, :coordinator1)
    template = create(:template, :template1)
    tq = create(:template_question, :template_question1)
    tq2 = create(:template_question, :template_question2)
    sign_in admin
    # DELETE /admins/templates/:template_id/template_questions/:id(.:format)    template_questions#destroy
    delete :destroy, params: { template_id: template.id, id: tq.id }
    expect(response).to redirect_to(edit_template_path(template))
    expect(TemplateQuestion.find_by(title: 'How are you')).to be_nil
  end
end
