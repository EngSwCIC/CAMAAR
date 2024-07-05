require 'rails_helper'

RSpec.describe UserTurma, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:turma) }
  end
end