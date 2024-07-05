# spec/models/template_spec.rb
require 'rails_helper'

RSpec.describe Template, type: :model do
  describe "associations" do
    it "should belong to user" do
      user = User.create(email: "test_user@example.com", password: "password")  # Ajuste para atributos válidos no seu modelo User
      template = Template.new(user: user)

      expect(template.user).to eq(user)
    end
  end
end
