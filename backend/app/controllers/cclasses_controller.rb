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
    @semester = params[:semester]
    if @semester.nil?
      @semester = '2021.2'
    end

    @likert_answers = LikertScaleAnswer
      .select('id, answer, question_answer_id, likert_scale_question_id')

    # pega a resposta de cada questão de cada membro de questões tipo likert
    # likert_scale_question_answers: likert_scale_question_id => [answer, ...]
    @likert_scale_question_answers = Hash.new
    @likert_answers.each do |answer|
      if @likert_scale_question_answers[answer.likert_scale_question_id].nil?
        @likert_scale_question_answers[answer.likert_scale_question_id] = []
      end
      @likert_scale_question_answers[answer.likert_scale_question_id]
        .push(answer.answer)
    end


    @survey_questions = SurveyQuestion
      .where(question_type_id: 3) # 3 = Likert Scale

    @survey_questions_with_answers = Hash.new
    @survey_questions.each do |question|
      # passa por cada questão de um survey e associa as respostas
      @likert_scale_questions_with_answers = []
      question.likert_scale_questions.each do |l_question|
        @likert_scale_questions_with_answers.push({
          id: l_question.id,
          question: l_question.question,
          scale_points: l_question.scale_points,
          survey_question_id: l_question.survey_question_id,
          answers: @likert_scale_question_answers[l_question.id]
        })
      end

      # adiciona as questões de um survey com suas respostas em um hash
      @survey_questions_with_answers[question.survey_id] = {
        id: question.id,
        survey_id: question.survey_id,
        question_type_id: question.question_type_id,
        question: question.question,
        likert_scale_questions: @likert_scale_questions_with_answers,
      }
    end


    @surveys = Survey
      .select('surveys.*')
      .where('surveys.semester': @semester.sub('.', '/'))

    # associa as respostas de cada questão de cada survey
    @survey_with_question_answers = []
    @surveys.each do |survey|
      @survey_with_question_answers.push({
        id: survey.id,
        name: survey.name,
        description: survey.description,
        semester: survey.semester,
        survey_questions: @survey_questions_with_answers[survey.id]
      })
    end

    # TODO: melhorar as queries
    # TODO: fazer os testes
    render json: @survey_with_question_answers
  end
end
