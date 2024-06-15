# frozen_string_literal: true

# Basic question type. Has no input.
#
class Question < ApplicationRecord
  belongs_to :template # TODO: Use `{ polymorphic: true }` once we create the forms table

  def input?
    false
  end

  def objective?
    !input? && !self[:answer].nil?
  end
end
