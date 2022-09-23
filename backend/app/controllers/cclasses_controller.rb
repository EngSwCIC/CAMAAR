# Classe Controller que define as ações capazes de serem feitas para manipular um Cclass
# por meio da aplicação

class CclassesController < ApplicationController

  def initialize
    @cclass = {}
    @answer = {}
    @answers = {}
    @answers = {
      rows: [],
      columns: [],
      average_rows: [],
      charts: []
    }
  end

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
    set_cclass

    if @cclass.survey_answers.count != 0
      set_average_rows
      set_charts
      set_answers
      set_questions
    end

    render json: @answers, status: :ok
  end

  def set_average_rows
    @answer = {}
    @cclass.survey_answers.first.question_answers
    .includes(:survey_question, survey_question: [:question_type, :question_answers], likert_scale_answers: [:likert_scale_question])
    .each do |question_answer|
      survey_question = question_answer.survey_question
      survey_question_question = survey_question.question
      case (survey_question.question_type.name)
        when "likert_scale"
          set_likert_scale_average_answers(question_answer.likert_scale_answers)
        when "multiple_choice"
          @answer[survey_question_question] = survey_question.question_answers.average("answer").to_f.round(1)
        else
          @answer[survey_question_question] = ""
      end
    end
    @answers[:average_rows].push(@answer)
  end

  def set_likert_scale_average_answers(likert_scale_answers)
    likert_scale_answers.each do |likert_scale_answer|
      likert_scale_question = likert_scale_answer.likert_scale_question
      @answer[likert_scale_question.question] = likert_scale_question.likert_scale_answers.average("answer").to_f.round(1)
    end
  end

  def set_charts
    @cclass.survey_answers.first.question_answers
    .includes(:survey_question, survey_question: [:question_type, :question_answers], likert_scale_answers: [:likert_scale_question])
    .select { |question_answer| question_answer.survey_question.question_type.name == "likert_scale" }.each do |question_answer|
      set_likert_scale_answers_charts(question_answer.likert_scale_answers)
    end
  end

  def set_likert_scale_answers_charts(likert_scale_answers)
    likert_scale_answers.each do |likert_scale_answer|
      set_likert_scale_answers_chart(likert_scale_answer)
      end
  end

  def set_likert_scale_answers_chart(likert_scale_answer)
    chart = {
      labels: [],
      data: []
    }
    likert_scale_answer_question = likert_scale_answer.likert_scale_question
      chart[:question] = likert_scale_answer_question.question
      likert_scale_answer_question.scale_points.times.each do |point|
        point += 1
        chart[:labels].push(point)
        chart[:data].push(likert_scale_answer_question.likert_scale_answers.group_by(&:answer)[point].to_a.count)
      end
      @answers[:charts].push(chart)
  end

  def set_answers
    @cclass.survey_answers
    .includes(:question_answers, question_answers: [:likert_scale_answers, :survey_question, likert_scale_answers: [:likert_scale_question]])
    .each do |survey_answer|
      set_answer(survey_answer)
    end
  end

  def set_answer(survey_answer)
    @answer = {}
    survey_answer.question_answers.each do |question_answer|
      survey_question = question_answer.survey_question
      if (survey_question.question_type.name == "likert_scale")
        set_likert_scale_answers(question_answer.likert_scale_answers)
      else
        @answer[survey_question.question] = question_answer.answer
      end
    end
    @answers[:rows].push(@answer)
  end

  def set_likert_scale_answers(likert_scale_answers)
    likert_scale_answers.each do |likert_scale_answer|
      @answer[likert_scale_answer.likert_scale_question.question] = likert_scale_answer.answer
    end
  end

  def set_questions
    @cclass.survey_answers.first.question_answers.each do |question_answer|
      survey_question = question_answer.survey_question
      if (survey_question.question_type.name == "likert_scale")
        set_likert_scale_questions(survey_question.likert_scale_questions)
      else
        @answers[:columns].push(survey_question.question)
      end
    end
  end

  def set_likert_scale_questions(likert_scale_questions)
    likert_scale_questions.each do |likert_scale_question|
      @answers[:columns].push(likert_scale_question.question)
    end
  end

  def show
    @cclass = Cclass.find(params[:id])
    render json: @cclass, status: :ok
  end

  def set_cclass
    @cclass = Cclass.find(params[:id])
  end
end