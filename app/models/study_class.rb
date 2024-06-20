class StudyClass < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :docente, :class_name => :User, :foreign_key => "docente_id"

  # def docente
  #   # retorna uma instancia de user em vez de ser so o id
  #   User.find(@docente_id)
  # end
end