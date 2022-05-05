require 'rails_helper'

RSpec.describe "SurveyAnswers", type: :request do
  describe "POST /create" do
    before do
      subject = Subject.create(code: 'CIC0105', name: 'Engenharia de Software')
      @cclass = Cclass.create(code: 'TA', semester: '2021.2', time: '35M12', subject: subject)
      @member = Member.create(name: 'Genaina', course: 'DEPTO CIÊNCIAS DA COMPUTAÇÃO',
                              registration: '83807519491', username: '83807519491',
                              degree: 'Doutorado', occupation: 'docente',
                              email: 'genaina@email.com')
      @enrollment = Enrollment.create(member: @member, cclass: @cclass)
      @survey = Survey.create(name: 'Pesquisa Docente sobre o Ensino Remoto', semester: @cclass.semester,
                              description: 'Para cada disciplina que estiver ministrando, selecione a identificação da disciplina/turma. Julgue os itens seguintes para analisar cada disciplina separadamente. Você poderá analisar até o máximo de 3 disciplinas em que estiver dando aulas.'
      )
      @question_1 = SurveyQuestion.create(question_type: "Escala", question: "O plano de ensino entregue foi ajustado", optional: false, survey_id: @survey.id)
      @question_2 = SurveyQuestion.create(question_type: "Caixa de Seleção", question: "Metodologia de avaliação utilizada", optional: false, survey_id: @survey.id)
      @option1 = Option.create(option: 'Provas Síncronas', survey_question_id: @question_2.id)
      @option2 = Option.create(option: 'Provas Assíncronas', survey_question_id: @question_2.id)
      @option3 = Option.create(option: 'Trabalhos', survey_question_id: @question_2.id)
    end

    let(:survey_answer_params) do {
      member_id: @member.id, cclass_id: @cclass.id, survey_id: @survey.id, answers: [{
                                                                                       survey_question_id: 1,
                                                                                       content: 2
                                                                                     },
                                                                                     {
                                                                                       survey_question_id: 2,
                                                                                       content: 'teste',
                                                                                       selected_options: [1, 2],
                                                                                       custom_option: "Opção customizada"
                                                                                     }
      ]
    }
    end

    context 'with valid params' do
      before do
        SurveyAnswer.delete_all
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'creates the survey answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        expect(survey_answers).not_to be nil
      end

      it 'creates the questions answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        answers = Answer.where(survey_answer_id: survey_answers.id)
        expect(answers.size).to eq(survey_answer_params[:answers].size)
      end

      it 'creates the custom option for selection box answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        answers = Answer.where(survey_answer_id: survey_answers.id)
        selection_box_answer = answers.filter { |a| a.survey_question.question_type == 'Caixa de Seleção' }.last
        custom_option = SelectedOption.where(answer_id: selection_box_answer.id, custom_option: survey_answer_params[:answers].last[:custom_option])
        expect(custom_option).not_to be nil
      end

      it 'creates the selected options for selection box answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        answers = Answer.where(survey_answer_id: survey_answers.id)
        selection_box_answer = answers.filter { |a| a.survey_question.question_type == 'Caixa de Seleção' }.last
        selected_options = SelectedOption.where(answer_id: selection_box_answer.id)
        extra_option = survey_answer_params[:answers].last[:custom_option] ? 1 : 0
        expect(selected_options.size).to eq(
                                           survey_answer_params[:answers].last[:selected_options].size +
                                             extra_option
                                         )
      end
    end

    context 'without survey id' do
      before do
        survey_answer_params[:survey_id] = nil
        SurveyAnswer.delete_all
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create the survey answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        expect(survey_answers).to be nil
      end
    end

    context 'without member id' do
      before do
        survey_answer_params[:member_id] = nil
        SurveyAnswer.delete_all
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create the survey answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        expect(survey_answers).to be nil
      end
    end

    context 'without cclass id' do
      before do
        survey_answer_params[:cclass_id] = nil
        SurveyAnswer.delete_all
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create the survey answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        expect(survey_answers).to be nil
      end
    end

    context 'without answers array' do
      before do
        survey_answer_params[:answers] = nil
        SurveyAnswer.delete_all
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create the survey answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        expect(survey_answers).to be nil
      end
    end

    context 'when answers is not an array' do
      before do
        survey_answer_params[:answers] = { }
        SurveyAnswer.delete_all
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create the survey answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        expect(survey_answers).to be nil
      end
    end

    context 'when selected option does not exist' do
      before do
        SurveyAnswer.delete_all
        Option.delete_all
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create any selected options' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        answers = Answer.where(survey_answer_id: survey_answers.id)
        selection_box_answer = answers.filter { |a| a.survey_question.question_type == 'Caixa de Seleção' }.last
        selected_options = SelectedOption.where(answer_id: selection_box_answer.id)
        expect(selected_options.size).to eq(0)
      end
    end

    context 'when only custom option is passed' do
      before do
        survey_answer_params[:answers].last[:selected_options] = nil
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns bad request' do
        expect(response).to have_http_status(:created)
      end

      it 'creates the custom option for selection box answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        answers = Answer.where(survey_answer_id: survey_answers.id)
        selection_box_answer = answers.filter { |a| a.survey_question.question_type == 'Caixa de Seleção' }.last
        custom_option = SelectedOption.where(answer_id: selection_box_answer.id, custom_option: survey_answer_params[:answers].last[:custom_option])
        expect(custom_option).not_to be nil
      end
    end

    context 'when question does not exist' do
      before do
        survey_answer_params[:answers].last[:selected_options] = nil
        Option.delete_all
        SurveyQuestion.delete_all
        post '/survey_answers/create', params: survey_answer_params
      end

      it 'returns bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create answers' do
        survey_answers = SurveyAnswer.find_by(enrollment_id: @enrollment.id, survey_id: @survey.id)
        answers = Answer.where(survey_answer_id: survey_answers.id)
        expect(answers.size).to eq(0)
      end
    end
  end
end
