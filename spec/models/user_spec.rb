require 'rails_helper'
require 'bcrypt'

require 'simplecov'
SimpleCov.start

RSpec.describe User, type: :model do
  describe '.find' do
    context 'when user exists' do
      let!(:user) { User.create(email: "test12@example.com", salt: "teste", password: "teste") }

      it 'returns the user with the specified email' do
        found_user = User.find("test12@example.com")
        expect(found_user).to eq(user)
      end
    end

    context 'when user does not exist' do
      it 'returns nil' do
        found_user = User.find("nonexistent@example.com")
        expect(found_user).to be_nil
      end
    end
  end

  describe '.authenticate' do
    let!(:user) { User.create(email: "test@example.com", salt: "$2a$12$9sauXRcV/alggmsRweudU.", password: "$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu") }
    
    context 'when user_id and password are correct' do
      it 'returns true' do
        authenticated = User.authenticate(user.id, "TOKEN_587")
        expect(authenticated).to be true
      end
    end

    context 'when user_id is incorrect' do
      it 'returns false' do
        authenticated = User.authenticate(-1, "TOKEN_587")
        expect(authenticated).to be false
      end
    end

    context 'when password is incorrect' do
      it 'returns false' do
        authenticated = User.authenticate(user.id, "wrongpassword")
        expect(authenticated).to be false
      end
    end
  end

  describe '#generate_session_key' do
    let!(:user) { User.create(email: "test@example.com", password: "password123", salt: BCrypt::Engine.generate_salt) }

    it 'generates and saves a new session key' do
      expect {
        user.generate_session_key
      }.to change { user.session_key }
      expect(user.session_key).to be_present
    end
  end

  describe '.criarUser' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          User.criarUser("newuser@example.com", "password123", "password123")
        }.to change(User, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect {
          User.criarUser("newuser@example.com", "", "")
        }.not_to change(User, :count)
      end

      it 'returns nil' do
        expect {
          result = User.criarUser("", "", "")
          expect(result).to be_nil
        }.not_to change(User, :count)
      end

      it 'returns nil if passwords do not match' do
        expect {
          result = User.criarUser("newuser@example.com", "password123", "differentpassword")
          expect(result).to be_nil
        }.not_to change(User, :count)
      end
    end
  end
end
