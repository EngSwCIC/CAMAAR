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

  # Valid is not the same as 'correct'. This just checks if the answer is possible.
  def valid_answer?(input)
    options.include?(input)
  end
end
