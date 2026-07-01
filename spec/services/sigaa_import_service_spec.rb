require 'rails_helper'
require 'tempfile'

RSpec.describe SigaaImportService, type: :service do
  describe '.processar' do
    context 'quando os dados do JSON são válidos' do
      # Mudado de xit para it para reativar o teste com sucesso!
      it 'processa os arquivos e extrai as informações com sucesso' do
        # Criamos o mock estruturado IGUAL ao classes.json real
        json_classes = [
          {
            "code" => "CIC0105",
            "name" => "ENGENHARIA DE SOFTWARE",
            "class" => {
              "classCode" => "TA",
              "semester" => "2021.2",
              "time" => "35M12"
            }
          }
        ].to_json

        # Criamos o mock estruturado IGUAL ao class_members.json real
        json_membros = [
          {
            "code" => "CIC0105",
            "classCode" => "TA",
            "semester" => "2021.2",
            "dicente" => [
              {
                "nome" => "Ana Clara",
                "curso" => "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula" => "190084006",
                "usuario" => "190084006",
                "formacao" => "graduando",
                "ocupacao" => "dicente",
                "email" => "ana@unb.br"
              }
            ],
            "docente" => {
              "nome" => "MARISTELA TERTO",
              "departamento" => "DEPTO CIÊNCIAS DA COMPUTAÇÃO",
              "formacao" => "DOUTORADO",
              "usuario" => "83807519491",
              "email" => "mholanda@unb.br",
              "ocupacao" => "docente"
            }
          }
        ].to_json

        # Escreve nos arquivos temporários físicos
        arquivo_classes = Tempfile.new(['classes', '.json'])
        arquivo_classes.write(json_classes)
        arquivo_classes.rewind

        arquivo_membros = Tempfile.new(['membros', '.json'])
        arquivo_membros.write(json_membros)
        arquivo_membros.rewind

        # Executa o service real tocando o banco de dados
        resultado = SigaaImportService.processar(arquivo_classes.path, arquivo_membros.path)

        expect(resultado).to be_truthy
        expect(Pessoa.exists?(usuario: '190084006')).to be_truthy
        expect(Disciplina.exists?(codigo: 'CIC0105')).to be_truthy

        # Limpeza
        arquivo_classes.close; arquivo_classes.unlink
        arquivo_membros.close; arquivo_membros.unlink
      end
    end
  end
end