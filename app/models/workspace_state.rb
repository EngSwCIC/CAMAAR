class WorkspaceState < ApplicationRecord
  def self.instance
    first_or_create!(data: Camaar::Workspace::DEFAULT_STATE.deep_dup)
  end
end
