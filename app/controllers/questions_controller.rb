class QuestionsController < ApplicationController
  before_action :setup_template

  def new
  end

  def destroy
  end

  private

  def setup_template
    @template = Template.new(questions: [Question.new])
  end
end
