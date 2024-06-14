# frozen_string_literal: true

# Basic question type. Has no input.
#
class Question < ApplicationRecord
  belongs_to :template

  def answer
    nil
  end
end
