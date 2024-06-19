class StudyClass < ActiveRecord::Base
  has_many :users, through: :study_classes_users

  def docente
    # retorna uma instancia de user em vez de ser so o id
    User.find(self[:docente])
  end
end