require 'rails_helper'

RSpec.describe QuestionAnswersController, :type => :controller do
  describe "QuestionAnswerController specs" do

    context "POST #create" do
    
      context "tests scenarios" do

          before(:all) do
            # SETUP

            # Create User, Survey, CCLASS
            @role = create(:role)
            @member = create(:member, role_id: @role.id)
            @subject = create(:subject)
            @cclass = create(:cclass, subject_id: @subject.id)
            @survey = create(:survey, role_id: @role.id)
            
            # Create Questions
            question_type_d = FactoryBot.create(:question_type, name: "discursive")
            question_type_mc = FactoryBot.create(:question_type, name: "multiple_choice")
            question_type_ls = FactoryBot.create(:question_type, name: "likert_scale")
            
            question_d = create(:survey_question, survey_id: @survey.id, question_type_id: question_type_d.id)
            question_mc = create(:survey_question, survey_id: @survey.id, question_type_id: question_type_mc.id)
            question_ls = create(:survey_question, survey_id: @survey.id, question_type_id: question_type_ls.id)

            likert_question_1 = create(:likert_scale_question, survey_question_id: question_ls.id, question_number: 1)
            likert_question_2 = create(:likert_scale_question, survey_question_id: question_ls.id, question_number: 1)
            likert_question_3 = create(:likert_scale_question, survey_question_id: question_ls.id, question_number: 1)
            

            # Valid request
            @valid_params = { :survey_id => @survey.id,
              :cclass_id => @cclass.id,
              :member_id=> @member.id,
              :answers_attributes=>
                [
                  {:question_answer=> question_d.id, :question_type=>{:name=>"discursive"}, :required => true, :content =>"teste"},
                  {:question_answer=> question_mc.id, :question_type=>{:name=>"multiple_choice"}, :required => true, :content =>"option 1", :option_number =>1},
                  {:question_answer=> question_ls.id, :question_type=>{:name=>"likert_scale"}, :required => true,
                  :likert_answers_attributes => [
                    {:likert_question_id =>likert_question_1.id, :content =>"Discordo totalmente"},
                    {:likert_question_id =>likert_question_2.id, :content =>"Discordo totalmente"},
                    {:likert_question_id =>likert_question_3.id, :content =>"Discordo totalmente"},
                  ]
                  }
                ],
              :question_answer =>{}}
          end

          after(:all) do
            # TEARDOWN
            # Undo database changes
            @cclass.destroy!
            @survey.destroy!
            @member.destroy!
            @role.destroy!
            @subject.destroy!
          end
        

        it "should return a success status code if params are valid" do
          # EXERCISE
          post :create, :params => @valid_params
          
          # VERIFY
          expect(response).to have_http_status(:success)
        end
          
        it "should return an error if member doesn't exists" do
          # SETUP
          invalid_params = @valid_params
          invalid_params[:member_id] = Member.all.last.id + 1
          
          # EXERCISE
          post :create, :params => invalid_params
          
          # VERIFY
          expect(response).to have_http_status(:unprocessable_entity)
        end
        
        it "should return an error if cclass doesn't exists" do
          # SETUP
          invalid_params = @valid_params
          invalid_params[:cclass_id] = Cclass.all.last.id + 1

          # EXECUTE
          post :create, :params => invalid_params
          
          # VERIFY
          expect(response).to have_http_status(:unprocessable_entity)
        end
    
        it "should return an error if survey doesn't exists" do
          # SETUP
          invalid_params = @valid_params
          invalid_params[:index_question_answers_on_survey_question_id] = Survey.all.last.id + 1
          
          # EXERCISE
          post :create, :params => invalid_params
          
          # VERIFY
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return an error if at least one required question content is nil" do
          # SETUP
          invalid_params = @valid_params
          invalid_params[:answers_attributes][1][:content] = nil

          # EXECUTE
          post :create, :params => invalid_params

          # VERIFY
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return an error if at least one field of a required likert question content is nil" do
          # SETUP
          invalid_params = @valid_params
          invalid_params[:answers_attributes][2][:likert_answers_attributes][0][:content] = nil

          # EXECUTE
          post :create, :params => invalid_params

          # VERIFY
          expect(response).to have_http_status(:unprocessable_entity) 
        end
        
      end
    end      
  end
end