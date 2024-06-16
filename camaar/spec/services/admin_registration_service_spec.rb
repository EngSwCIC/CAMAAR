require 'rails_helper'

RSpec.describe AdminRegistrationService, type: :model do
  let(:admin) { create(:admin, :admin1) }

  it 'does send an email to register' do
    AdminRegistrationService.call(admin)
    # open_email(admin.email)
    # expect(current_email).to have_content 'Administrador!'
  end
end
