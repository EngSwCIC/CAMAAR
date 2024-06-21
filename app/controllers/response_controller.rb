class ResponseController < AvaliacoesController
  def index
    @form_request = FormRequest.find(params[:avaliaco_id])
    render layout: "home"
  end
  def create
    @form_request = FormRequest.find(params[:avaliaco_id])

    answers = []
    params.each do |name, value|
      if name.start_with?("answer_")
        if value == ""
          flash[:alert] = "Por favor, responda todas as perguntas obrigatórias"
          redirect_to "/avaliacoes/#{@form_request.id}/response"
          return
        end

        answers << value
      end
    end

    @form_response = FormResponse.new
    @form_response.study_class = @form_request.study_class
    @form_response.template = @form_request.template
    @form_response.response = answers.to_json
    @form_response.save!

    @form_request.answered = true
    @form_request.save!

    flash[:notice] = "Obrigado pelas respostas"
    redirect_to "/avaliacoes"
  end
end
