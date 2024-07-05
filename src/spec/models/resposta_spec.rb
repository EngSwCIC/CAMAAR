require 'rails_helper'

RSpec.describe Resposta, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:questao) }
    it { should belong_to(:formulario) }
  end
end