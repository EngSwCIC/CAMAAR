# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'json'

senha_padrao = 'senha12345' 

# Carrega participantes
file = File.read('./db/class_members.json')
turma_data = JSON.parse(file)

for turma in turma_data do
    docente = turma['docente']
    if (!User.exists?(email: docente['email']))
        User.create(nome: docente['nome'], password: senha_padrao, isAdmin: true, departamento: docente['departamento'], formacao: docente['formacao'],
                    usuario: docente['usuario'], email: docente['email'], ocupacao: docente['ocupacao'])
        
        puts 'Docente ' + docente['nome'] + ' criado.'
    end
end

file = File.read('./db/classes.json')
classes_data = JSON.parse(file)

# Carrega turmas
for data in classes_data do
    if (!Materia.exists?(code: data['code']))
        materia = Materia.create!(code: data['code'], nome: data['name'], )
    else
        materia = Materia.find_by(code: data['code'])
    end

    prof = User.find_by(ocupacao: docente['ocupacao'])
    class_info = data['class']

    if (!Turma.exists?(classCode: data['code'], semestre: class_info['semester'],
        horario: class_info['time'], materia: materia, id_professor: prof.id))

        Turma.create(classCode: data['code'], semestre: class_info['semester'],
        horario: class_info['time'], materia: materia, id_professor: prof.id)
        puts 'Turma ' + class_info['classCode'] + ' - ' + class_info['time'] + ' criado.'

    end
end

# Carrega participantes
file = File.read('./db/class_members.json')
turma_data = JSON.parse(file)

#Para cada turma
for turma in turma_data do
    dicentes = turma['dicente']
    docente = turma['docente']
    turmaBD = Turma.find_by(classCode: turma['code'])

    #Adicione o aluno no banco caso ja nao exista
    for dicente in dicentes do
        if (!User.exists?(email: dicente['email']))
            member = User.create(nome: dicente['nome'], password: senha_padrao, curso: dicente['curso'],
            matricula: dicente['matricula'], usuario: dicente['matricula'],
            formacao: dicente['formacao'], ocupacao: dicente['ocupacao'],
            email: dicente['email'])
    
            puts 'Dicente ' + dicente['nome'] + ' criado.'
        end
        
        dicenteBD = User.find_by(usuario: dicente['matricula'])
        if (!UserTurma.find_by(user_id: dicenteBD.id, turma_id: turmaBD.id))
            UserTurma.create(user_id: dicenteBD.id, turma_id: turmaBD.id)
            puts 'Adicionando dicente ' + dicenteBD.nome + ' na turma ' + turmaBD.classCode
        end
    end

    docenteBD = User.find_by(usuario: docente['usuario'])
    if (!UserTurma.find_by(user_id: docenteBD.id, turma_id: turmaBD.id))
        UserTurma.create(user_id: docenteBD.id, turma_id: turmaBD.id)
        puts 'Adicionando docente ' + docenteBD.nome + ' na turma ' + turmaBD.classCode
    end
end




# # Cria um admin
admin = User.create(email: "admin@email.com", password: senha_padrao, isAdmin: true, nome:'Admin', usuario: 'admin')
userComun = User.create(email: "user@email.com", password: senha_padrao, isAdmin: false, nome: 'User', usuario: 'user')

# # Cria questoes
# questao_dissertativa = Questao.create(tipo: "dissertativa")
# questao_multipla = Questao.create(tipo: "multipla escolha")