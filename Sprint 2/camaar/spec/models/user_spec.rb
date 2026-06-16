require 'rails_helper'

RSpec.describe User, type: :model do

  # ─── Factory base reutilizada em todos os testes ───────────────────────────
  let(:valid_attrs) do
    {
      name:      'Arthur',
      email:     'arthur@unb.br',
      matricula: '190000000',
      role:      'user',
      password:  'senha123'
    }
  end

  # ─── Validações ───────────────────────────────────────────────────────────

  describe 'validações' do

    it 'é válido com atributos válidos' do
      expect(User.new(valid_attrs)).to be_valid
    end

    it 'é inválido sem nome' do
      expect(User.new(valid_attrs.except(:name))).not_to be_valid
    end

    it 'é inválido sem email' do
      expect(User.new(valid_attrs.except(:email))).not_to be_valid
    end

    it 'não aceita roles inválidas' do
      expect(User.new(valid_attrs.merge(role: 'coordenador'))).not_to be_valid
    end

    it 'aceita role admin' do
      expect(User.new(valid_attrs.merge(role: 'admin'))).to be_valid
    end

    it 'não permite matrículas duplicadas' do
      User.create!(valid_attrs)

      duplicado = User.new(
        valid_attrs.merge(email: 'outro@unb.br', matricula: '190000000')
      )

      expect(duplicado).not_to be_valid
    end

    it 'não permite emails duplicados' do
      User.create!(valid_attrs)

      duplicado = User.new(
        valid_attrs.merge(matricula: '190000001', email: 'arthur@unb.br')
      )

      expect(duplicado).not_to be_valid
    end

  end

  # ─── #admin? ──────────────────────────────────────────────────────────────

  describe '#admin?' do

    it 'retorna true para administradores' do
      expect(User.new(role: 'admin').admin?).to be true
    end

    it 'retorna false para usuários comuns' do
      expect(User.new(role: 'user').admin?).to be false
    end

  end

  # ─── #first_access? ───────────────────────────────────────────────────────

  describe '#first_access?' do

    it 'retorna true quando é primeiro acesso' do
      expect(User.new(first_access: true).first_access?).to be true
    end

    it 'retorna false quando não é primeiro acesso' do
      expect(User.new(first_access: false).first_access?).to be false
    end

  end

  # ─── #password_defined? ───────────────────────────────────────────────────

  describe '#password_defined?' do

    it 'retorna false quando ainda é primeiro acesso' do
      expect(User.new(first_access: true).password_defined?).to be false
    end

    it 'retorna true quando a senha já foi definida' do
      expect(User.new(first_access: false).password_defined?).to be true
    end

  end

  # ─── #needs_password_reset? ───────────────────────────────────────────────

  describe '#needs_password_reset?' do

    it 'retorna true no primeiro acesso' do
      expect(User.new(first_access: true).needs_password_reset?).to be true
    end

    it 'retorna false após a definição da senha' do
      expect(User.new(first_access: false).needs_password_reset?).to be false
    end

  end

  # ─── .find_for_database_authentication ───────────────────────────────────

  describe '.find_for_database_authentication' do

    before do
      User.create!(valid_attrs)
    end

    it 'encontra usuário pelo email' do
      user = User.find_for_database_authentication(login: 'arthur@unb.br')

      expect(user).not_to be_nil
      expect(user.matricula).to eq('190000000')
    end

    it 'encontra usuário pela matrícula' do
      user = User.find_for_database_authentication(login: '190000000')

      expect(user).not_to be_nil
      expect(user.email).to eq('arthur@unb.br')
    end

    it 'retorna nil para email inexistente' do
      user = User.find_for_database_authentication(login: 'naoexiste@unb.br')

      expect(user).to be_nil
    end

    it 'retorna nil para matrícula inexistente' do
      user = User.find_for_database_authentication(login: '999999999')

      expect(user).to be_nil
    end

  end

end