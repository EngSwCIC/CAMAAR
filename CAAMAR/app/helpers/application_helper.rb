module ApplicationHelper
    # TODO implement
    def is_user_admin(user)
        true
    end
    
    # TODO implement
    def get_current_user_id()
        1
    end

    def get_forms_info(forms)
        classes = JSON.parse(File.read('db/json/classes.json'))
        class_members = JSON.parse(File.read('db/json/class_members.json'))
        # Add class_data to the filtered forms
        forms.map do |form|
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
