class Template < ApplicationRecord
  belongs_to :user, optional: true

  validates :nome, presence: true
  has_many :versions,
         class_name: "Template",
         foreign_key: "parent_template_id"

  belongs_to :parent_template,
           class_name: "Template",
           optional: true
end