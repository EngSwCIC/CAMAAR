require "rails_helper"

describe User do
  subject{FactoryGirl.create(:user)}

  context "Validation" do
    it "should be valid" do
      expect(subject).to be_valid
    end

    it "should not be valid without 'nome'" do
      subject.nome = nil
      expect(subject).to_not be_valid
    end

    it "should not be valid without 'email'" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "should not be valid without 'usuario'" do
      subject.usuario = nil
      expect(subject).to_not be_valid
    end

    # por algum motivo eh valido ???
    it "should not be valid without 'password'" do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it "should not be valid without 'formacao'" do
      subject.formacao = nil
      expect(subject).to_not be_valid
    end

    it "should not be valid with password too short" do
      subject.password = "senha"
      expect(subject).to_not be_valid
      expect(subject.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end
end
