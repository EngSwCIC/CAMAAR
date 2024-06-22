class SendFormsController < ApplicationController
  def index
    @templates = Template.all
    @study_classes = StudyClass.all
    render layout: "home"
  end

  def create
    puts params
    template = Template.find(params[:templates].to_i)
    puts template
    params.each do |k, v|
      if k.starts_with?("study_class_") && v == "1"
        sc_id = k[12..].to_i
        puts sc_id

        sc = StudyClass.find(sc_id)
        puts sc
        sc.users.each do |u|
          if FormRequest.find_by(user_id: u.id, study_class_id: sc.id).nil?
            FormRequest.create(template: template, study_class: sc, user: u)
          end
        end
        if sc.docente.present? && FormRequest.find_by(user_id: sc.docente.id, study_class_id: sc.id).nil?
          FormRequest.create(template: template, study_class: sc, user: sc.docente)
        end
      end
    end
  end
end