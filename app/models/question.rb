# frozen_string_literal: true

# Basic question type. Has no input.
#
class Question < ApplicationRecord
  belongs_to :template

  def input?
    false
  end

  def objective?
    !input? && !self[:answer].nil?
  end
end
