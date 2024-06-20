class StudyClass < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :docente, :class_name => :User, :foreign_key => "docente_id", optional: true
end