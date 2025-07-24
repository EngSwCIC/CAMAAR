# app/models/template.rb
class Template < ApplicationRecord
  belongs_to :user
  has_many :template_questions, dependent: :destroy
  has_many :template_responses, dependent: :destroy

  # ADICIONAR ESTA LINHA - permite criar perguntas junto com o template
  accepts_nested_attributes_for :template_questions,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :name, presence: true, uniqueness: true

  scope :published, -> { where(published: true) }

  def total_responses
    template_responses.count
  end

  def response_from_user(user)
    template_responses.find_by(user: user)
  end

  def answered_by?(user)
    template_responses.exists?(user: user)
  end
end
