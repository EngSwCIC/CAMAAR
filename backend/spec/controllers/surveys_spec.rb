require 'rails_helper'

RSpec.describe SurveysController, :type => :controller do

  let(:valid_attributes) {{
    name: 'name',
    description: 'desc',
    expiration_date: 2.hours.from_now,
    semester: '2021/2',
    role: Role.create(name: 'docente', description: 'docente'),
  }}

  let(:expired_attributes) {{
    name: 'name',
    description: 'desc',
    expiration_date: 2.hours.ago,
    semester: '2021/2',
  }}

  let(:invalid_attributes) {{
    description: 'desc',
    expiration_date: 2.hours.from_now,
    semester: '2021/2',
  }}
  
  
  describe "POST" do
    it "renders a successful response" do
      survey = Survey.create(valid_attributes)
      post :create, params: {survey: {
          name: "Questionário 3",
          description: "this is a test survey 3",
          role_id: 2,
          expiration_date: "Thu, 21 Jun 2028 12:15:50 -0300",
          semester: "2021/2",
          survey_questions: [
            {
              question_number: 1,
              question: "Sugestões ou comentários adicionais para esta disciplina.",
              question_type_id: 1,
              question_type: "likert",
              optional: true
            },
          ],
          role: Role.create(name: 'docente', description: 'docente')
        }
      }
      expect(response.body).to include('docente')
      expect(response.body).to include('2021/2')
      expect(response.body).to include('survey_questions')
      expect(response).to have_http_status(200)
    end
  end
end