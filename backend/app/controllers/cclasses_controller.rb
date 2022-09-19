# Classe Controller que define as ações capazes de serem feitas para manipular um Cclass
# por meio da aplicação

class CclassesController < ApplicationController
  ##
  # Método que renderiza as +CClasses+ de um membro cujo +id+ foi passado
  # por parâmetro (+params+).
  #
  # Caso o membro identificado por +params[:member_id]+ não seje encontrado,
  # uma resposta com status +not_found (404)+ é renderizada. Caso o membro seja
  # encontrado, renderiza uma resposta contendo as +CClasses+ e +Subjects+ desse membro,
  # juntamente com o status +ok (200)+.

  def index
    if !params[:member_id].nil?
      @member = Member.find(params[:member_id])
      if !@member.blank?
        @cclasses = []
        for enrollment in @member.enrollments do
          @cclasses.push(enrollment.cclass)
        end
        render json: @cclasses, include: :subject
        return
      end
    end
    @members = Enrollment.where('cclass_id = 4')
    puts @members
    @cclasses = Cclass.select('subjects.name, subjects.code as subjectCode, cclasses.*').joins(:subject)
    render json: @cclasses, status: :ok
  end


  def show
    @cclass = Cclass.find(params[:id])
    render json: @cclass, status: :ok
  end

  def reports
    # TODO: melhorar as queries (provavelmente dá pra fazer a mesma coisa com menos queries)
    # TODO: tornar essa rota privada para admins (quando tivermos essa feature)

    # caso o semestre não seja passado, assume o semestre atual
    @semester = params[:semester] || '2021.2'

    @surveys = Survey
      .select('surveys.*')
      .where('surveys.semester': @semester)
      .map { |survey| {
        id: survey.id,
        name: survey.name,
        semester: survey.semester,
        survey_questions: self.class.extract_survey_likert_questions(survey)
      } }

    render json: @surveys
  end

  def self.extract_survey_likert_questions(survey)
    survey.survey_questions.where('question_type_id': 3).map { |question| {
      question: question.question,
      likert_scale_questions: self.extract_likert_questions(question)
    } }
  end

  def self.extract_likert_questions(question)
    question.likert_scale_questions.map do |likert_question| 
      {
        id: likert_question.id,
        question: likert_question.question,
        scale_points: likert_question.scale_points,
        answers: self.extract_likert_answers(likert_question)
      }
    end
  end

  def self.extract_likert_answers(likert_question)
    likert_question.likert_scale_answers.map { |answer| answer.answer }
  end
end
