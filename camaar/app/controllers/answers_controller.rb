class StudentAnswersController < ApplicationController
    def create
        @student_answer = StudentAnswer.new(student_answer_params)
  
        if @student_answer.save
            redirect_to user_path(user)
        else
            flash[:alert] = "Erro ao salvar a resposta."
            redirect_back(fallback_location: root_path)
        end
    end
  
    def student_answer_params
        params.require(:student_answer).permit(:question_type, :answers, :form_question_id, :student_id)
    end
  end
  