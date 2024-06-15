# frozen_string_literal: true

# A question with multiple choices.
#
class MultipleChoiceQuestion < Question
  def input?
    true
  end

  def options
    format = self[:format]
    return [] if format.nil?

    format.split '|'
  end
end
