class ResponseController < ApplicationController
  def show
    puts "beep"
    @form_request = FormRequest.find(params[:id])
    render layout: "home"
  end

  def update
    puts "create"
    puts @form_request
    puts params

    answers = []
    params.each do |name, value|
      if name.start_with?("answer_")
        answers << value
      end
    end

    response = FormResponse.new(
      study_class: @form_request.study_class,
      template: @form_request.template,
      response: answers.to_json
    )
    response.save!

    @form_request.answered = true
    @form_request.save!
  end
end
