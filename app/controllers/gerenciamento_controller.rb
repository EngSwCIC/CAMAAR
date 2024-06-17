class GerenciamentoController < ApplicationController

  def index
  end

  def import
    hash_class = JSON.parse(File.read("classes.json"))
    hash_members = JSON.parse(File.read("class_members.json"))

    if !(check_class_json hash_class) or !(check_class_members_json hash_members)
      flash[:alert] = "Dados inválidos"
    else
      flash[:notice] = "Data imported successfully"
    end

    render 'gerenciamento/index'
  end

  def check_class_members_json(json)
    keys_class_members = ["code", "classCode", "semester", "dicente", "docente"].sort
    keys_dicente = ["nome", "curso", "matricula", "usuario", "formacao", "ocupacao", "email"].sort
    keys_docente = ["nome", "departamento", "formacao", "usuario", "email", "ocupacao"].sort

    if json.respond_to? :keys
      false
    else
      json.each do |obj|
        if not obj.respond_to? :keys or obj.keys.sort != keys_class_members
          return false
        else
          # dicente eh uma lista de objs
          if obj["dicente"].respond_to? :keys
            return false
          else
            obj["dicente"].each do |aluno|
              if not aluno.respond_to? :keys or aluno.keys.sort != keys_dicente
                return false
              end
            end
          end

          if not obj["docente"].respond_to? :keys or obj["docente"].keys.sort != keys_docente
            return false
          end
        end
      end

      true
    end
  end

  def check_class_json(json)
    keys_classes = ["code", "class", "name"].sort
    keys_class = ["classCode", "semester", "time"].sort

    # sao JSONs de lista, nao eh um objeto direto
    if json.respond_to? :keys
      false
    else
      json.each do |obj|
        if not obj.respond_to? :keys or obj.keys.sort != keys_classes
          return false
        else
          if not obj["class"].respond_to? :keys or obj["class"].keys.sort != keys_class
            return false
          end
        end
      end

      true
    end
  end

end