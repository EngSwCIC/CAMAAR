class SurveyAnswersController < ApplicationController

  ##
  # Método para criar as respostas de um questionário
  #
  # O método recebe como parâmetro um objeto, contendo:
  # - +member_id+ (Integer): id do membro
  # - +cclass_id+ (Integer): id da turma
  # - +survey_id+ (Integer): id do questionário
  # - +answers+ (Array de objetos): Lista de respostas, cada uma contendo:
  #   - +survey_question_id+ (Integer): id da questão respondida
  #   - +content+ (String): Conteúdo da resposta
  #   - +selected_options+ (Array de integers): Opcional, ids das opções selecionadas se a questão for do tipo caixa de seleção
  #   - +custom_option+ (String): Opcional, conteúdo da opção customizada "outro" para questões de caixa de seleção
  #
  # Método não retorna nada, apenas responde a requisção com o status http +created+.
  #
  # Levanta um erro caso algum parâmetro não tenha sido passado corretamente e o renderiza como uma mensagem em um json.
  #
  # Pode criar instâncias das models +SurveyAnswer+, +Answer+ e +SelectedOption+.

  def create
    enrollment = Enrollment.find_by!(member_id: params[:member_id], cclass_id: params[:cclass_id])
    survey_answers = SurveyAnswer.new(enrollment: enrollment, survey_id: params[:survey_id])
    answer_params = params.require(:answers)
    if answer_params
      survey_answers.save!
      create_answers(answer_params, survey_answers)
    end
    head(:created)
  rescue StandardError => e
    render json: { message: e }, status: :bad_request
  end

  private

  def create_answers (answer_params, survey_answers)
    answer_params.each do |answer|
      a = Answer.new(answer.permit(:survey_question_id, :content))
      a.content = nil if a.survey_question.question_type == 'Caixa de Seleção'
      a.survey_answer_id = survey_answers.id
      a.save!
      if a.survey_question.question_type == 'Caixa de Seleção'
        create_selected_options(answer, a.id)
      end
    end
  end

  def create_selected_options (answer, answer_id)
    if answer[:selected_options]
      answer[:selected_options].map(&:to_i).each do |option|
        SelectedOption.create!(option_id: option, answer_id: answer_id)
      end
    end

    custom_option = answer.permit(:custom_option)[:custom_option]
    SelectedOption.create!(custom_option: custom_option, answer_id: answer_id) if custom_option
  end
end
