require 'zip'
require 'csv'

class GerenciamentoController < ApplicationController
    def index
    end

    def show_templates
        unless helpers.is_user_admin(nil)
            redirect_to "/"
            return
        end
        
        path = 'db/json/templates.json'
        data = File.read(path)
        @templates = JSON.parse(data)
    end

    def results_popup
        all_forms = JSON.parse(File.read('db/json/forms.json'))
        forms = helpers.get_forms_info(all_forms)

        render partial: 'results_popup', layout: false, locals: { forms: forms }
    end

    def generate_csv
        selected_form_ids = []
        params.each do |key, value|
          if key.start_with?("form_id-") && value == "1"
            form_id = key.split("-").last.to_i
            selected_form_ids << form_id
          end
        end

        all_answers = JSON.parse(File.read('db/json/answers.json'))

        csvs = {}
        selected_form_ids.each do |form_id|
            headers = []
            rows = all_answers
                .select { |a| a['form_id'] == form_id }
                .map do |form_answer|
                    row = {}
                    form_answer["answers"].each do |answer|
                        question_id = answer['question_id']
                        headers[question_id - 1] ||= "question_#{question_id}_answer"
                        row["question_#{question_id}_answer"] = answer['answer']
                    end
                    row
                end
    
            csv_string = CSV.generate(headers: true) do |csv|
                csv << headers
                rows.each { |row| csv << row.values_at(*headers) }
            end
    
            csvs[form_id] = csv_string
        end

        temp_dir = Rails.root.join('tmp', 'csvs')
        FileUtils.mkdir_p(temp_dir) unless File.directory?(temp_dir)

        csvs.each do |form_id, csv_data|
            File.open(temp_dir.join("form_#{form_id}.csv"), 'w') { |file| file.write(csv_data) }
        end

        zip_file = Rails.root.join('tmp', 'CSVs.zip')
        File.delete(zip_file) if File.exist?(zip_file)
        Zip::File.open(zip_file, Zip::File::CREATE) do |zip|
            csvs.each do |form_id, _|
                zip.add("form_#{form_id}.csv", temp_dir.join("form_#{form_id}.csv"))
            end
        end

        send_file zip_file
    end
  end
  