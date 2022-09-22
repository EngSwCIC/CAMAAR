require 'rails_helper'

RSpec.describe SurveysController, :type => :controller do
  context "SurveysController open"

  before(:all) do
    @role = create(:role)
            @member = create(:member, role_id: @role.id)
            @subject = create(:subject)
            @cclass = create(:cclass, subject_id: @subject.id)
            @survey = create(:survey, role_id: @role.id)

            # Cria apenas uma pergunta teste
            question_type_d = create(:question_type, name: "discursive")
            question_d = create(:survey_question, survey_id: @survey.id, question_type_id: question_type_d.id)

            #Cria o survey
            @valid_params = { :survey_id => @survey.id,
              :cclass_id => @cclass.id,
              :member_id=> @member.id,
              :answers_attributes=>
                [
                  {:question_answer=> question_d.id, :question_type=>{:name=>"discursive"}, :required => true, :content =>"teste"},
                ],
              :question_answer =>{}}
            end

          it "Caso de sucesso" do
            post :create, :params => @valid_params
            expect(response).to have_http_status(:success)
          end


end