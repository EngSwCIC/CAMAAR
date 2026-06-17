require 'json'

class SigaaImporter
  def self.import_classes(json_content)
    begin
      data = JSON.parse(json_content)
      data = [data] unless data.is_a?(Array)

      data.each do |item|
        next unless item.is_a?(Hash)
        
        # Validate structure
        raise "campos obrigatórios ausentes" unless item['code'] && item['class'] && item['class']['classCode']

        disciplina = Disciplina.find_or_create_by!(code: item['code']) do |d|
          d.name = item['name']
        end

        Turma.find_or_create_by!(
          classCode: item['class']['classCode'],
          semester: item['class']['semester'],
          disciplina: disciplina
        ) do |t|
          t.time = item['class']['time']
        end
      end
      { success: true, message: "Dados de turmas importados com sucesso: #{data.size} novas turmas processadas" }
    rescue JSON::ParserError
      { success: false, message: "Erro na estrutura do arquivo: campos obrigatórios ausentes ou JSON inválido" }
    rescue => e
      { success: false, message: "Erro na estrutura do arquivo: #{e.message}" }
    end
  end

  def self.import_members(json_content)
    begin
      data = JSON.parse(json_content)
      data = [data] unless data.is_a?(Array)
      
      data.each do |item|
        next unless item.is_a?(Hash)
        
        disciplina = Disciplina.find_by(code: item['code'])
        next unless disciplina

        turma = Turma.find_by(classCode: item['classCode'], semester: item['semester'], disciplina: disciplina)
        next unless turma

        # Import Discentes
        (item['dicente'] || []).each do |d_data|
          Discente.find_or_create_by!(matricula: d_data['matricula'], turma: turma) do |d|
            d.nome = d_data['nome']
            d.curso = d_data['curso']
            d.usuario = d_data['usuario']
            d.formacao = d_data['formacao']
            d.ocupacao = d_data['ocupacao']
            d.email = d_data['email']
          end
          
          User.find_or_create_by!(matricula: d_data['matricula']) do |u|
            u.email = d_data['email']
            u.role = 'discente'
            u.generate_invitation_token!
          end
        end

        # Import Docente
        if doc_data = item['docente']
          Docente.find_or_create_by!(usuario: doc_data['usuario'], turma: turma) do |doc|
            doc.nome = doc_data['nome']
            doc.departamento = doc_data['departamento']
            doc.formacao = doc_data['formacao']
            doc.email = doc_data['email']
            doc.ocupacao = doc_data['ocupacao']
          end

          User.find_or_create_by!(matricula: doc_data['usuario']) do |u|
            u.email = doc_data['email']
            u.role = 'docente'
            u.generate_invitation_token!
          end
        end
      end
      { success: true, message: "Participantes importados com sucesso" }
    rescue JSON::ParserError
      { success: false, message: "Erro na estrutura do arquivo: campos obrigatórios ausentes ou JSON inválido" }
    rescue => e
      { success: false, message: "Erro na estrutura do arquivo: #{e.message}" }
    end
  end
end
