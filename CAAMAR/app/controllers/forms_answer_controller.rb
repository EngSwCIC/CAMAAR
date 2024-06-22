class FormsAnswerController < ApplicationController
  def index

  end


  def new
    @forms = JSON.parse(File.read("db/json/forms.json"))
    templates = JSON.parse(File.read("db/json/templates.json"))
    @form = @forms.find {|form| form["id"] == params[:form_id].to_i}
    @template = templates.find {|template| template["id"] == @form["template_id"].to_i}
    puts @template, params[:id]


  end

  def create
    answers_file_path = "db/json/answers.json"
    forms_file_path = "db/json/forms.json"
    @forms = JSON.parse(File.read(forms_file_path))
    @form = @forms.find {|form| form["id"] == params[:form_id].to_i}
    solver = @form["solvers"].find { |solver| solver["id"] == params[:solver_id].to_i }
    solver["is_solved"] = true
    File.write(forms_file_path, JSON.pretty_generate(@forms))
    if File.file?(answers_file_path)
      @answers = JSON.parse(File.read(answers_file_path))
      answer_id = @answers.map {|answer| answer["id"]}.max || 0
      answer_id += 1
    else
      @answers = JSON.parse("{}")
      answer_id = 1
    end
    answer_hash = {"id" => answer_id}
    personal_answers = []
    params.each do |key, value|
      next if  key != "form_id" && key.to_i.to_s != key # Ignorar essas chaves
      if key.to_i.to_s == key
        if value.to_i.to_s == value
          personal_answers.push({"question_id" => key.to_i, "answer" => value.to_i})

        else
          personal_answers.push({"question_id" => key.to_i, "answer" => value})
        end

      else
        if value.to_i.to_s == value
          answer_hash[key] = value.to_i
        else
          answer_hash[key] = value
        end

      end
    end
    answer_hash["questions"] = personal_answers
    @answers << answer_hash
    puts "esse é o hash #{personal_answers}"
    File.write(answers_file_path, JSON.pretty_generate(@answers))
  end


end
