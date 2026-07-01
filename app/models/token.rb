# frozen_string_literal: true

class Token < ApplicationRecord
  belongs_to :usuario,
    class_name: "Usuario",
    inverse_of: :tokens

  validates :usuario, presence: true
  validates :value, presence: true, uniqueness: true
  validates :tipo, presence: true
  validates :expires_at, presence: true

  def expirado?
    expires_at < Time.current
  end
end
