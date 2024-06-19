class StudyClass < ActiveRecord::Base
  has_and_belongs_to_many :users

  def docente
    # retorna uma instancia de user em vez de ser so o id
    User.find(self[:docente])
  end
end