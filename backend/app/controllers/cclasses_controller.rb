class CclassesController < ApplicationController
    
  def index
    turmasCadastradas = Cclass.joins(:subject).select("cclasses.id, cclasses.code as classCode, cclasses.semester, cclasses.time, subjects.code as code, subjects.name")
    puts turmasCadastradas.length
    # turmasCadastradas = turmasCadastradas.map { |turma| 
    #   materiaDaTurma = Subject.where(:id => turma['subject_id']).first
    #   puts materiaDaTurma.code
    #   turma['subject_id'] = materiaDaTurma.code
    #   turma
    # } 
    render json: {
        classes: turmasCadastradas
    }, status: :ok
  end
end