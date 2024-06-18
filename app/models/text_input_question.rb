# frozen_string_literal: true

# A question with textual imput.
#
class TextInputQuestion < Question
  def input?
    true
  end
end
