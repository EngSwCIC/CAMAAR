# frozen_string_literal: true

# == Schema Information
#
# Table name: cursos
#
#  id         :integer          not null, primary key
#  nome       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Model representing a course (curso)
class Curso < ApplicationRecord
  validates :nome, presence: true, length: { minimum: 2 }

  has_many :disciplinas, dependent: :destroy
end
