class FormcreatesController < ApplicationController
    def import
        template_id = params[:id].to_i
        codigo = params[:codigo]
        semestre = params[:semestre]
        turma = params[:turma]
        tipo = params[:tipo]

        path = 'db/json/class_members.json'
        if File.file?(path)
            json_members = JSON.parse(File.read(path))

            json_members.each do |jm|
                if jm["code"] == codigo and jm["semester"] == semestre and jm["classCode"] == turma

                    # matched, now send generate forms for each discente/docente

                    path2 = 'db/json/forms.json'
                    if File.file?(path2)
                        forms = JSON.parse(File.read(path2))
                    else
                        forms = []
                    end
                    

                    if tipo == "docente"
                        item = {
                            "id" => forms.length() + 1,
                            "template_id" => template_id,
                            "class" => {
                                "subject_code" => codigo,
                                "semester" => semestre,
                                "code" => turma
                            },
                            "solvers" => [
                                {
                                    "id" => jm["docente"]["usuario"],
                                    "is_solved" => false
                                }
                            ]
                        }
                        forms << item

                    elsif tipo == "discente"
                        item = {
                            "id" => forms.length() + 1,
                            "template_id" => template_id,
                            "class" => {
                                "subject_code" => codigo,
                                "semester" => semestre,
                                "code" => turma
                            }
                        }
                        alunos = jm["dicente"]
                        item["solvers"] = []
                        
                        alunos.each do |aluno| 
                            item["solvers"] << {
                                "id" => aluno["usuario"],
                                "is_solved" => false
                            }
                        end
                    
                        forms << item

                    end

                    
                    File.open(path2, 'w') do |f|
                        f.write(JSON.pretty_generate(forms))
                    end

                    break
                end
            end
        end

    end
end
