class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
    render json: @subjects, status: :ok
  end

  def show
    @subject = Subject.find(params[:id])
    render json: @subject, status: :ok
  end

  ##
  # Importa todas as matérias (subjects) do banco de dados e guarda em um array de objetos.
  #
  # Em subjects, há iteração para a criação de um novo array,
  # com cada matéria desconstruída em código (name) e classes (classes).
  #
  # Para cada subject, coleta-se as informações de cada classe, com a média das notas (grade)
  # e o código da classe (name).
  #
  # Retorna um JSON de disciplinas e suas informações, como nome e turmas.

  def admin_report
    subjects = Subject.all

    subjects = subjects.map { |s| { name: s.code, classes: s.cclasses } }
    subjects = subjects.map do |s|
      {
        name: s[:name],
        classes: s[:classes].map do |c|
          {
            grade: get_class_mean(c),
            name: c.code
          }
        end
      }
    end

    render json: subjects
  end

  private

  ##
  # Calcula a média das turmas.
  #
  # Retorna a média se houver nota,
  # caso contrário, retorna "0".

  def get_class_mean(oi)
    a = oi.enrollments.map { |b| b.grade }
    return a.inject(0) { |sum, x| sum + x.to_i } / a.size unless a.size == 0
  end
end
