# frozen_string_literal: true

module Auth
  class TokenIssuer
    DEFAULT_EXPIRATION = 10.minutes

    def self.call(usuario:, tipo:, expires_in: DEFAULT_EXPIRATION)
      new(usuario: usuario, tipo: tipo, expires_in: expires_in).call
    end

    def initialize(usuario:, tipo:, expires_in:)
      @usuario = usuario
      @tipo = tipo
      @expires_in = expires_in
    end

    def call
      token_value.tap do |value|
        usuario.tokens.create!(
          value: value,
          tipo: tipo,
          expires_at: expires_in.from_now
        )
      end
    end

    private

    attr_reader :usuario, :tipo, :expires_in

    def token_value
      @token_value ||= SecureRandom.hex(16)
    end
  end
end
