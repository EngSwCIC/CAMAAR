class ImportInconsistency < ApplicationRecord
  validates :source, :message, presence: true
end
