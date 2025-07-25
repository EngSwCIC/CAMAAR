# frozen_string_literal: true

# == Schema Information
#
# Table name: turmas
#
#  id            :integer          not null, primary key
#  semestre      :string
#  disciplina_id :integer          not null
#  professor_id  :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Classe responsável por representar turmas
class Turma < ApplicationRecord
  belongs_to :disciplina, optional: true
  belongs_to :professor, class_name: 'User'
  has_many :matriculas, dependent: :destroy
  has_many :alunos, through: :matriculas, source: :user

  validates :semestre, presence: true
end
