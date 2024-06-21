class AvaliacoesController < ApplicationController
  def index
    if File.file?('db/json/forms.json')
      all_forms = JSON.parse(File.read('db/json/forms.json'))
      # Filter forms to only show unanswered ones by the current user
      curr_user = helpers.get_current_user_id()
      unanswered_forms = all_forms.select do |form|
        solver = form["solvers"].find { |s| s["id"] == curr_user }
        !solver.nil? && !solver["is_solved"]
      end

      @forms = helpers.get_forms_info(unanswered_forms)
    else
      @forms = []
    end
  end
end
