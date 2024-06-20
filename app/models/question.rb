class Question < ApplicationRecord
  belongs_to :formlike, polymorphic: true
  has_many :answers

  def input?
    false
  end

  def objective?
    !input? && !self[:answer].nil?
  end
end