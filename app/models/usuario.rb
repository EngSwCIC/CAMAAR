class Usuario < ApplicationRecord
  self.table_name = "usuarios"

  belongs_to :curso, optional: true
  belongs_to :departamento, optional: true
  has_many :matriculas, dependent: :destroy
  has_many :turmas, through: :matriculas
  has_many :respostas, dependent: :destroy

  attr_reader :password
  attr_accessor :password_confirmation, :validating_password_rules

  validates :email, presence: true

  # Custom password hashing using bcrypt to work with existing 'senha_hash' column
  # Autentica o usuário comparando a senha não criptografada.
  #
  # = Parâmetros:
  # * +unencrypted_password+ - A senha em texto puro que o usuário tenta usar.
  #
  # = Retorno:
  # * Retorna um boolean, true se a senha for válida, false caso contrário.
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def authenticate(unencrypted_password)
    return false if senha_hash.blank?
    BCrypt::Password.new(self.senha_hash) == unencrypted_password
  rescue BCrypt::Errors::InvalidHash
    false
  end

  # Atribui uma nova senha e gera o hash com bcrypt.
  #
  # = Parâmetros:
  # * +unencrypted_password+ - A nova senha em texto puro.
  #
  # = Retorno:
  # * Retorna o próprio hash gerado caso haja senha, ou nil.
  #
  # = Efeitos Colaterais:
  # * Atualiza o atributo `senha_hash` da instância (não salva no banco automaticamente).
  def password=(unencrypted_password)
    @password = unencrypted_password
    self.senha_hash = BCrypt::Password.create(unencrypted_password) if unencrypted_password.present?
  end

  validate :password_security_rules, if: :validating_password_rules

  # Verifica se o usuário tem permissão para gerenciar uma determinada turma.
  #
  # = Parâmetros:
  # * +turma+ - Objeto do tipo Turma.
  #
  # = Retorno:
  # * Retorna um boolean indicando se o usuário pertence ao mesmo departamento da turma.
  #
  # = Efeitos Colaterais:
  # * Nenhum.
  def pode_gerenciar_turma?(turma)
    departamento_id == turma.departamento_id
  end

  # Helpers to generate tokens
  # Gera um token para a configuração inicial do usuário.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna true caso a operação de salvar seja bem-sucedida.
  #
  # = Efeitos Colaterais:
  # * Altera o banco de dados (salva setup_token, setup_token_sent_at, e setup_token_used na base).
  def generate_setup_token!
    self.setup_token = SecureRandom.hex(20)
    self.setup_token_sent_at = Time.current
    self.setup_token_used = false
    save!
  end

  # Gera um token para o reset de senha do usuário.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna true caso a operação de salvar seja bem-sucedida.
  #
  # = Efeitos Colaterais:
  # * Altera o banco de dados (salva reset_token, reset_token_sent_at, e reset_token_used na base).
  def generate_reset_token!
    self.reset_token = SecureRandom.hex(20)
    self.reset_token_sent_at = Time.current
    self.reset_token_used = false
    save!
  end

  private

  # Aplica as regras de segurança para senhas durante a validação.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Nil, apenas adiciona erros na instância de usuário.
  #
  # = Efeitos Colaterais:
  # * Adiciona mensagens de erro à instância se houver violações das regras.
  def password_security_rules
    return handle_missing_passwords if password.blank? || password_confirmation.blank?

    check_password_match
    check_password_length
    check_password_numbers
    check_password_lowercase
  end

  # Lida com casos de senhas não preenchidas.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna um array de erros ou nil.
  #
  # = Efeitos Colaterais:
  # * Adiciona erro de campo obrigatório na instância.
  def handle_missing_passwords
    errors.add(:password, "Preencha todos os campos obrigatórios")
  end

  # Checa se a senha e a confirmação coincidem.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna um array de erros se falhar, ou nil se passar.
  #
  # = Efeitos Colaterais:
  # * Adiciona erro se as senhas não coincidirem.
  def check_password_match
    errors.add(:password, "As senhas não coincidem") if password != password_confirmation
  end

  # Verifica se o tamanho da senha é adequado.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna um array de erros se falhar, ou nil.
  #
  # = Efeitos Colaterais:
  # * Adiciona erro se a senha for muito curta.
  def check_password_length
    errors.add(:password, "Senha deve ter no mínimo 6 caracteres") if password.length < 6
  end

  # Verifica a presença de números na senha.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna um array de erros se falhar, ou nil.
  #
  # = Efeitos Colaterais:
  # * Adiciona erro caso a senha não tenha números.
  def check_password_numbers
    errors.add(:password, "A senha deve conter pelo menos um número") unless password.match(/\d/)
  end

  # Verifica se a senha possui apenas minúsculas indevidamente.
  #
  # = Parâmetros:
  # * Nenhum.
  #
  # = Retorno:
  # * Retorna um array de erros se falhar, ou nil.
  #
  # = Efeitos Colaterais:
  # * Adiciona erro caso possua letra maiúscula (verificar o comportamento desejado, está barrando maiúsculas).
  def check_password_lowercase
    errors.add(:password, "A senha deve conter apenas letras minúsculas") if password.match(/[A-Z]/)
  end
end
