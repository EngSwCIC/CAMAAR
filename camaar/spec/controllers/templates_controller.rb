require 'rails_helper'
RSpec.describe TemplatesController, type: :controller do
  let(:admin) { create(:admin, :admin1) }
  @controller = TemplatesController.new
  before do
    allow(controller).to receive(:authenticate_admin!).and_return(true)
    allow(controller).to receive(:current_admin).and_return(admin)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  it 'allows to access :new template route' do
    departament = create(:department, :departament1)
    coordinator = create(:coordinator, :coordinator1)
    sign_in admin

    get :new
    template = build(:template, :template1)
    expect(response).to redirect_to(edit_template_path(template))
  end

  # it 'allows to access :update template route' do
  #   departament = create(:department, :departament1)
  #   coordinator = create(:coordinator, :coordinator1)
  #   sign_in admin
  #   template = create(:template,:template1)
  #   template2 = build(:template,:template2)
  #   @template = template
  #   @template_name = template2.name
  #   put :update, params: {id: template.id}
  #   expect(response).to redirect_to(edit_template_path(template))
  # end

  it 'allows to access delete :destroy template route' do
    departament = create(:department, :departament1)
    coordinator = create(:coordinator, :coordinator1)
    sign_in admin
    template = create(:template, :template1)
    @template = template
    delete :destroy, params: { id: template.id }
    old_temp = build(:template, :template1)
    expect(Template.find_by(id: old_temp.id)).to be_nil
    expect(response).to redirect_to(templates_path)
  end
end
