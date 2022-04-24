require 'rails_helper'

RSpec.describe "Surveys", type: :request do
  describe "GET /show" do
    context "when survey does not exist" do
      before do
        Survey.delete_all
        get '/surveys/1'
      end

      it 'returns a not_found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns custom not found message' do
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Pesquisa não encontrada' })
      end
    end

    context "when survey exists" do
      before do
        Survey.delete_all
        @survey = Survey.create(name: "Pesquisa Docente sobre o Ensino Remoto", semester: "2021.2",
                                description: "Para cada disciplina que estiver ministrando, selecione a identificação da disciplina/turma. Julgue os itens seguintes para analisar cada disciplina separadamente. Você poderá analisar até o máximo de 3 disciplinas em que estiver dando aulas."
        )
        @question_1 = SurveyQuestion.create(question_type: "Escala", question: "O plano de ensino entregue foi ajustado", optional: false, survey_id: @survey.id)
        @question_2 = SurveyQuestion.create(question_type: "Caixa de Seleção", question: "Metodologia de avaliação utilizada", optional: false, survey_id: @survey.id)
        get "/surveys/#{@survey.id}"
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns custom survey info and its questions inside a single object' do
        expect(JSON.parse(response.body)).to eq({
                                                  'id' => @survey.id,
                                                  'name' => @survey.name,
                                                  'description' => @survey.description,
                                                  'semester' => @survey.semester,
                                                  'survey_questions' => [{
                                                                           'question' => @question_1.question,
                                                                           'question_type' => @question_1.question_type,
                                                                           'optional' => @question_1.optional
                                                                         },
                                                                         {
                                                                           'question' => @question_2.question,
                                                                           'question_type' => @question_2.question_type,
                                                                           'optional' => @question_2.optional
                                                                         }
                                                  ]
                                                })
      end
    end
  end
end
