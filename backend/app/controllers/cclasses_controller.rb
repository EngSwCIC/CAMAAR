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
    @cclasses = Cclass.select('subjects.name, subjects.code as subjectCode, cclasses.*').joins(:subject)
    render json: @cclasses, status: :ok
  end

  def get_answers
    @cclass = Cclass.find(params[:id])
    @answers = {
      rows: [],
      columns: [],
      average_rows: [],
      charts: []
    }

    if @cclass.survey_answers.count != 0

      @answer = {}
      @cclass.survey_answers.first.question_answers.includes(:survey_question, survey_question: [:question_type, :question_answers], likert_scale_answers: [:likert_scale_question]).each do |question_answer|
        case (question_answer.survey_question.question_type.name)
          when "likert_scale"
            question_answer.likert_scale_answers.each do |likert_scale_answer|
              @answer[likert_scale_answer.likert_scale_question.question] = likert_scale_answer.likert_scale_question.likert_scale_answers.average("answer").to_f.round(1)
            end
          when "multiple_choice"
            @answer[question_answer.survey_question.question] = question_answer.survey_question.question_answers.average("answer").to_f.round(1)
          else
            @answer[question_answer.survey_question.question] = ""
        end
      end
      @answers[:average_rows].push(@answer)

      @cclass.survey_answers.first.question_answers.includes(:survey_question, survey_question: [:question_type, :question_answers], likert_scale_answers: [:likert_scale_question]).select { |question_answer| question_answer.survey_question.question_type.name == "likert_scale" }.each do |question_answer|
        question_answer.likert_scale_answers.each do |likert_scale_answer|
          @chart = {
            labels: [],
            data: []
          }
            @chart[:question] = likert_scale_answer.likert_scale_question.question
             likert_scale_answer.likert_scale_question.scale_points.times.each do |i|
              @chart[:labels].push(i + 1)
              @chart[:data].push(likert_scale_answer.likert_scale_question.likert_scale_answers.group_by(&:answer)[i + 1].to_a.count)
             end
            @answers[:charts].push(@chart)
          end
      end

      @cclass.survey_answers.includes(:question_answers, question_answers: [:likert_scale_answers, :survey_question, likert_scale_answers: [:likert_scale_question]]).each do |survey_answer|
        @answer = {}
        survey_answer.question_answers.each do |question_answer|
          if (question_answer.survey_question.question_type.name == "likert_scale")
            question_answer.likert_scale_answers.each do |likert_scale_answer|
              @answer[likert_scale_answer.likert_scale_question.question] = likert_scale_answer.answer
            end
          else
            @answer[question_answer.survey_question.question] = question_answer.answer
          end
        end
        @answers[:rows].push(@answer)
      end

      @cclass.survey_answers.first.question_answers.each do |question_answer|
        if (question_answer.survey_question.question_type.name == "likert_scale")
          question_answer.survey_question.likert_scale_questions.each do |likert_scale_question|
            @answers[:columns].push(likert_scale_question.question)
          end
        else
          @answers[:columns].push(question_answer.survey_question.question)
        end
      end
    end
    render json: @answers, status: :ok
  end

  def show
    @cclass = Cclass.find(params[:id])
    render json: @cclass, status: :ok
  end
end
