require 'rails_helper'

RSpec.describe SignUpAvailable, type: :model do
  describe '.check_availability' do
    context 'when email and key exist' do
      let!(:sign_up_available) { SignUpAvailable.create(email: "test@example.com", key: "abc123") }

      it 'returns true' do
        expect(SignUpAvailable.check_availability("test@example.com", "abc123")).to be true
      end
    end

    context 'when email is correct but key is not' do
      let!(:sign_up_available) { SignUpAvailable.create(email: "test@example.com", key: "abc123") }
      it 'returns false' do
        expect(SignUpAvailable.check_availability("test@example.com", "invalidkey")).to be false
      end
    end

    context 'when email is wrong but not key is wrong' do
      let!(:sign_up_available) { SignUpAvailable.create(email: "test@example.com", key: "abc123") }
      it 'returns false' do
        expect(SignUpAvailable.check_availability("nonexistent@example.com", "abc123")).to be false
      end
    end
    context 'when email and key do not exist' do
      it 'returns false' do
        expect(SignUpAvailable.check_availability("nonexistent@example.com", "invalidkey")).to be false
      end
    end
  end

  describe '.create_by_json' do
    context 'when email does not exist' do
      it 'creates a new sign-up available entry' do
        expect {
          SignUpAvailable.create_by_json("newuser@example.com")
        }.to change(SignUpAvailable, :count).by(1)

        new_entry = SignUpAvailable.last
        expect(new_entry.email).to eq("newuser@example.com")
        expect(new_entry.key).not_to be_nil
      end
    end

    context 'when email already exists' do
      before do
        SignUpAvailable.create(email: "existing@example.com", key: "existingkey")
      end

      it 'does not create a new entry' do
        expect {
          SignUpAvailable.create_by_json("existing@example.com")
        }.not_to change(SignUpAvailable, :count)
      end
    end
  end

  describe '.send_keys_availables_sign_up' do
    it 'updates all keys to "TOKEN_587"' do
      SignUpAvailable.create(email: "test1@example.com", key: "12345")
      SignUpAvailable.create(email: "test2@example.com", key: "67890")

      SignUpAvailable.send_keys_availables_sign_up

      expect(SignUpAvailable.pluck(:key).uniq).to eq(["TOKEN_587"])
    end
  end
end
