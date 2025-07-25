require 'rails_helper'

RSpec.describe ImportService, type: :service do
  before do
    # Clear data before each test
    User.destroy_all
    Disciplina.destroy_all
    Curso.destroy_all
  end

  describe '.import_users' do
    context 'with valid user data array' do
      let(:user_data) do
        [
          {
            'nome' => 'João Silva',
            'email' => 'joao@example.com',
            'matricula' => '12345',
            'ocupacao' => 'dicente',
            'curso' => 'Ciência da Computação',
            'departamento' => 'CIC',
            'formacao' => 'Graduação'
          },
          {
            'nome' => 'Maria Santos',
            'email' => 'maria@example.com',
            'usuario' => '67890',
            'ocupacao' => 'docente',
            'curso' => 'Engenharia de Computação',
            'departamento' => 'ENE'
          }
        ]
      end

      it 'imports users successfully' do
        result = ImportService.import_users(user_data)

        expect(result).to include(
          success: true,
          imported: 2,
          skipped: 0
        )

        expect(User.count).to eq(2)
        
        joao = User.find_by(email: 'joao@example.com')
        expect(joao.name).to eq('João Silva')
        expect(joao.matricula).to eq('12345')
        expect(joao.role).to eq('aluno')
        expect(joao.curso).to eq('Ciência da Computação')
        
        maria = User.find_by(email: 'maria@example.com')
        expect(maria.name).to eq('Maria Santos')
        expect(maria.matricula).to eq('67890')
        expect(maria.role).to eq('professor')
      end

      it 'sets default password for imported users' do
        ImportService.import_users(user_data)
        
        user = User.find_by(email: 'joao@example.com')
        expect(user.valid_password?('123456')).to be true
      end
    end

    context 'with class_members.json format' do
      let(:class_members_data) do
        [
          {
            'dicente' => [
              {
                'nome' => 'Aluno 1',
                'email' => 'aluno1@example.com',
                'matricula' => '111',
                'ocupacao' => 'dicente'
              },
              {
                'nome' => 'Aluno 2',
                'email' => 'aluno2@example.com',
                'matricula' => '222',
                'ocupacao' => 'dicente'
              }
            ],
            'docente' => {
              'nome' => 'Professor 1',
              'email' => 'prof1@example.com',
              'matricula' => '333',
              'ocupacao' => 'docente'
            }
          }
        ]
      end

      it 'imports both students and teacher' do
        result = ImportService.import_users(class_members_data)

        expect(result).to include(
          success: true,
          imported: 3,
          skipped: 0
        )

        expect(User.count).to eq(3)
        expect(User.where(role: 'aluno').count).to eq(2)
        expect(User.where(role: 'professor').count).to eq(1)
      end
    end

    context 'with existing users' do
      let(:user_data) do
        [
          {
            'nome' => 'João Silva',
            'email' => 'joao@example.com',
            'matricula' => '12345',
            'ocupacao' => 'dicente'
          }
        ]
      end

      before do
        create(:user, email: 'joao@example.com', name: 'João Existente')
      end

      it 'skips existing users' do
        result = ImportService.import_users(user_data)

        expect(result).to include(
          success: true,
          imported: 0,
          skipped: 1
        )

        expect(User.count).to eq(1)
        expect(User.first.name).to eq('João Existente')
      end
    end

    context 'with invalid user data' do
      let(:invalid_data) do
        [
          {
            'nome' => 'Usuário Sem Email',
            'matricula' => '12345'
            # email em branco
          }
        ]
      end

      it 'skips users without email' do
        result = ImportService.import_users(invalid_data)

        expect(result).to include(
          success: true,
          imported: 0,
          skipped: 0
        )

        expect(User.count).to eq(0)
      end
    end

    context 'with user validation errors' do
      let(:user_data) do
        [
          {
            'nome' => '',  # nome vazio pode causar erro de validação
            'email' => 'invalid@example.com',
            'matricula' => '12345',
            'ocupacao' => 'dicente'
          }
        ]
      end

      it 'handles validation errors' do
        # Mock user to fail validation
        user_double = double('User')
        allow(User).to receive(:new).and_return(user_double)
        allow(user_double).to receive(:save).and_return(false)
        allow(user_double).to receive_message_chain(:errors, :full_messages).and_return(['Name cannot be blank'])

        result = ImportService.import_users(user_data)

        expect(result).to include(
          success: false
        )
        expect(result[:error]).to include('Name cannot be blank')
      end
    end

    context 'with database transaction error' do
      let(:user_data) do
        [
          {
            'nome' => 'Test User',
            'email' => 'test@example.com',
            'matricula' => '12345',
            'ocupacao' => 'dicente'
          }
        ]
      end

      it 'handles database errors' do
        allow(ActiveRecord::Base).to receive(:transaction).and_raise(StandardError.new('Database error'))

        result = ImportService.import_users(user_data)

        expect(result).to include(
          success: false,
          error: 'Database error'
        )
      end
    end

    context 'with single user object' do
      let(:single_user) do
        {
          'nome' => 'Single User',
          'email' => 'single@example.com',
          'matricula' => '99999',
          'ocupacao' => 'coordenador'
        }
      end

      it 'imports single user successfully' do
        result = ImportService.import_users(single_user)

        expect(result).to include(
          success: true,
          imported: 1,
          skipped: 0
        )

        user = User.find_by(email: 'single@example.com')
        expect(user.role).to eq('coordenador')
      end
    end
  end

  describe '.import_disciplines' do
    context 'with valid discipline data' do
      let(:discipline_data) do
        [
          {
            'code' => 'CIC0097',
            'name' => 'Algoritmos e Programação',
            'class' => {
              'classCode' => 'T01',
              'semester' => '2024.1',
              'time' => '08:00-10:00'
            }
          },
          {
            'code' => 'ENC0123',
            'name' => 'Sistemas Digitais'
          }
        ]
      end

      it 'imports disciplines successfully' do
        result = ImportService.import_disciplines(discipline_data)

        expect(result).to include(
          success: true,
          imported: 2,
          skipped: 0
        )

        expect(Disciplina.count).to eq(2)
        expect(Curso.count).to eq(2)

        disciplina1 = Disciplina.find_by(codigo: 'CIC0097')
        expect(disciplina1.nome).to eq('Algoritmos e Programação')
        expect(disciplina1.curso.nome).to eq('Ciência da Computação')
        expect(disciplina1.codigo_turma).to eq('T01')
        expect(disciplina1.semestre).to eq('2024.1')
        expect(disciplina1.horario).to eq('08:00-10:00')

        disciplina2 = Disciplina.find_by(codigo: 'ENC0123')
        expect(disciplina2.curso.nome).to eq('Engenharia de Computação')
      end
    end

    context 'with existing disciplines' do
      let(:discipline_data) do
        [
          {
            'code' => 'CIC0097',
            'name' => 'Algoritmos e Programação'
          }
        ]
      end

      before do
        curso = create(:curso, nome: 'Ciência da Computação')
        create(:disciplina, codigo: 'CIC0097', nome: 'Algoritmos e Programação', curso: curso)
      end

      it 'skips existing disciplines' do
        result = ImportService.import_disciplines(discipline_data)

        expect(result).to include(
          success: true,
          imported: 0,
          skipped: 1
        )

        expect(Disciplina.count).to eq(1)
      end
    end

    context 'with invalid discipline data' do
      let(:invalid_data) do
        [
          {
            'code' => '',
            'name' => 'Disciplina Sem Código'
          },
          {
            'code' => 'CIC0097',
            'name' => ''
          }
        ]
      end

      it 'skips disciplines without code or name' do
        result = ImportService.import_disciplines(invalid_data)

        expect(result).to include(
          success: true,
          imported: 0,
          skipped: 0
        )

        expect(Disciplina.count).to eq(0)
      end
    end

    context 'with discipline validation errors' do
      let(:discipline_data) do
        [
          {
            'code' => 'CIC0097',
            'name' => 'Test Discipline'
          }
        ]
      end

      it 'handles validation errors' do
        # Mock disciplina to fail validation
        disciplina_double = double('Disciplina')
        allow(Disciplina).to receive(:new).and_return(disciplina_double)
        allow(disciplina_double).to receive(:save).and_return(false)
        allow(disciplina_double).to receive_message_chain(:errors, :full_messages).and_return(['Code already taken'])

        result = ImportService.import_disciplines(discipline_data)

        expect(result).to include(
          success: false
        )
        expect(result[:error]).to include('Code already taken')
      end
    end

    context 'with database transaction error' do
      let(:discipline_data) do
        [
          {
            'code' => 'CIC0097',
            'name' => 'Test Discipline'
          }
        ]
      end

      it 'handles database errors' do
        allow(ActiveRecord::Base).to receive(:transaction).and_raise(StandardError.new('Database error'))

        result = ImportService.import_disciplines(discipline_data)

        expect(result).to include(
          success: false,
          error: 'Database error'
        )
      end
    end
  end

  describe '.determine_role' do
    it 'returns professor for docente' do
      expect(ImportService.determine_role('docente')).to eq('professor')
      expect(ImportService.determine_role('DOCENTE')).to eq('professor')
    end

    it 'returns aluno for dicente' do
      expect(ImportService.determine_role('dicente')).to eq('aluno')
      expect(ImportService.determine_role('DICENTE')).to eq('aluno')
    end

    it 'returns aluno for graduando' do
      expect(ImportService.determine_role('graduando')).to eq('aluno')
      expect(ImportService.determine_role('GRADUANDO')).to eq('aluno')
    end

    it 'returns coordenador for coordenador' do
      expect(ImportService.determine_role('coordenador')).to eq('coordenador')
      expect(ImportService.determine_role('COORDENADOR')).to eq('coordenador')
    end

    it 'returns aluno as default' do
      expect(ImportService.determine_role('unknown')).to eq('aluno')
      expect(ImportService.determine_role(nil)).to eq('aluno')
      expect(ImportService.determine_role('')).to eq('aluno')
    end
  end

  describe '.extract_course_from_code' do
    it 'extracts Ciência da Computação from CIC codes' do
      expect(ImportService.extract_course_from_code('CIC0097')).to eq('Ciência da Computação')
      expect(ImportService.extract_course_from_code('cic123')).to eq('Ciência da Computação')
    end

    it 'extracts Engenharia de Computação from ENC codes' do
      expect(ImportService.extract_course_from_code('ENC0123')).to eq('Engenharia de Computação')
      expect(ImportService.extract_course_from_code('enc456')).to eq('Engenharia de Computação')
    end

    it 'extracts Engenharia Mecatrônica from FTD codes' do
      expect(ImportService.extract_course_from_code('FTD0001')).to eq('Engenharia Mecatrônica')
      expect(ImportService.extract_course_from_code('ftd999')).to eq('Engenharia Mecatrônica')
    end

    it 'returns Curso Geral for unknown codes' do
      expect(ImportService.extract_course_from_code('XYZ123')).to eq('Curso Geral')
      expect(ImportService.extract_course_from_code('')).to eq('Curso Geral')
      expect(ImportService.extract_course_from_code(nil)).to eq('Curso Geral')
    end
  end
end
