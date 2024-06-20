class AvaliacoesController < ApplicationController
  def index
    all_forms = JSON.parse(File.read('db/json/forms.json'))
    # Filter forms to only show unanswered ones by the current user
    curr_user = helpers.get_current_user_id()
    unanswered_forms = all_forms.select do |form|
      solver = form["solvers"].find { |s| s["id"] == curr_user }
      !solver.nil? && !solver["is_solved"]
    end

    classes = JSON.parse(File.read('db/json/classes.json'))
    class_members = JSON.parse(File.read('db/json/class_members.json'))
    # Add class_data to the filtered forms
    @forms = unanswered_forms.map do |form|
      class_data = classes.find do |info|
        info["code"] == form["class"]["subject_code"] &&
        info["class"]["semester"] == form["class"]["semester"] &&
        info["class"]["classCode"] == form["class"]["code"]
      end
      
      teacher_name = (class_members.find do |info|
        info["code"] == form["class"]["subject_code"] &&
        info["semester"] == form["class"]["semester"] &&
        info["classCode"] == form["class"]["code"]
      end)["docente"]["nome"]
      class_data["class"]["teacher_name"] = teacher_name

      form.merge("class_data" => class_data)
    end
  end
end
