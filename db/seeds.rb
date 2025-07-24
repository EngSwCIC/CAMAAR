# db/seeds.rb
# Limpa os dados existentes (apenas em desenvolvimento)
if Rails.env.development?
  puts "🧹 Limpando dados existentes..."

  QuestionAnswer.destroy_all
  TemplateResponse.destroy_all
  TemplateQuestion.destroy_all
  Template.destroy_all
  User.destroy_all

  puts "👤 Criando usuários..."

  # Criar usuário admin
  admin = User.create!(
    nome: "Admin Teste",
    email: "admin@teste.com",
    password: "123456",
    password_confirmation: "123456",
    ocupacao: "admin"
  )

  # Criar usuário aluno
  aluno = User.create!(
    nome: "Aluno Teste",
    email: "aluno@teste.com",
    matricula: "012345678",
    password: "123456",
    password_confirmation: "123456",
    ocupacao: "discente"
  )

  # Criar mais alguns usuários para teste
  professor = User.create!(
    nome: "Professor Teste",
    email: "professor@teste.com",
    password: "123456",
    password_confirmation: "123456",
    ocupacao: "docente"
  )

  aluno2 = User.create!(
    nome: "Maria Silva",
    email: "maria@teste.com",
    matricula: "987654321",
    password: "123456",
    password_confirmation: "123456",
    ocupacao: "discente"
  )

  puts "📝 Criando templates de exemplo..."

  # Template 1: Avaliação da Disciplina
  template1 = admin.templates.create!(
    name: "Avaliação da Disciplina",
    description: "Formulário para avaliar a qualidade da disciplina e do professor"
  )

  template1.template_questions.create!([
    {
      question_text: "Como você avalia o conteúdo da disciplina?",
      question_type: "scale",
      required: true,
      position: 1
    },
    {
      question_text: "O professor foi claro nas explicações?",
      question_type: "radio",
      required: true,
      position: 2
    },
    {
      question_text: "Os materiais didáticos foram adequados?",
      question_type: "radio",
      required: true,
      position: 3
    },
    {
      question_text: "Você recomendaria esta disciplina para outros alunos?",
      question_type: "radio",
      required: true,
      position: 4
    },
    {
      question_text: "Deixe seus comentários e sugestões:",
      question_type: "text",
      required: false,
      position: 5
    }
  ])

  # Template 2: Avaliação do Semestre
  template2 = admin.templates.create!(
    name: "Avaliação Semestral",
    description: "Avaliação geral do semestre letivo"
  )

  template2.template_questions.create!([
    {
      question_text: "Como você avalia sua experiência geral neste semestre?",
      question_type: "scale",
      required: true,
      position: 1
    },
    {
      question_text: "A carga horária das disciplinas foi adequada?",
      question_type: "radio",
      required: true,
      position: 2
    },
    {
      question_text: "Os recursos da universidade (biblioteca, laboratórios, etc.) atenderam suas necessidades?",
      question_type: "radio",
      required: true,
      position: 3
    },
    {
      question_text: "Qual disciplina você mais gostou este semestre?",
      question_type: "text",
      required: false,
      position: 4
    },
    {
      question_text: "Sugestões para melhorar o próximo semestre:",
      question_type: "text",
      required: false,
      position: 5
    }
  ])

  # Template 3: Feedback da Infraestrutura
  template3 = admin.templates.create!(
    name: "Avaliação de Infraestrutura",
    description: "Avalie as instalações e recursos da universidade"
  )

  template3.template_questions.create!([
    {
      question_text: "Como você avalia as salas de aula?",
      question_type: "scale",
      required: true,
      position: 1
    },
    {
      question_text: "Os laboratórios de informática atendem suas necessidades?",
      question_type: "radio",
      required: true,
      position: 2
    },
    {
      question_text: "A biblioteca possui os recursos que você precisa?",
      question_type: "radio",
      required: true,
      position: 3
    },
    {
      question_text: "Como você avalia a limpeza das instalações?",
      question_type: "scale",
      required: true,
      position: 4
    },
    {
      question_text: "Sugestões para melhorar a infraestrutura:",
      question_type: "text",
      required: false,
      position: 5
    }
  ])

  puts "🎯 Criando algumas respostas de exemplo..."

  # Criar uma resposta de exemplo para mostrar como funciona
  response = template1.template_responses.create!(
    user: aluno2,
    submitted_at: 2.days.ago
  )

  # Respostas para as perguntas do template1
  template1.template_questions.each_with_index do |question, index|
    answer_text = case question.question_type
    when 'scale'
                    [ '1', '2', '3', '4', '5' ].sample
    when 'radio'
                    [ 'Discordo Totalmente', 'Discordo', 'Neutro', 'Concordo', 'Concordo Totalmente' ].sample
    when 'text'
                    case index
                    when 4
                      "Ótima disciplina! Aprendi muito sobre os conceitos fundamentais. Sugiro mais exercícios práticos."
                    else
                      "Resposta de exemplo"
                    end
    end

    response.question_answers.create!(
      template_question: question,
      answer_text: answer_text
    )
  end

  puts ""
  puts "=" * 50
  puts "✅ Seeds criados com sucesso!"
  puts "=" * 50
  puts ""
  puts "👤 USUÁRIOS CRIADOS:"
  puts "   📧 Admin: admin@teste.com / 123456"
  puts "   📧 Aluno: aluno@teste.com / 123456"
  puts "   📧 Professor: professor@teste.com / 123456"
  puts "   📧 Maria: maria@teste.com / 123456"
  puts ""
  puts "📝 TEMPLATES CRIADOS:"
  puts "   1. #{template1.name} (#{template1.template_questions.count} perguntas)"
  puts "   2. #{template2.name} (#{template2.template_questions.count} perguntas)"
  puts "   3. #{template3.name} (#{template3.template_questions.count} perguntas)"
  puts ""
  puts "📊 DADOS DE EXEMPLO:"
  puts "   • 1 resposta de exemplo no primeiro template"
  puts "   • #{template1.total_responses} resposta(s) total"
  puts ""
  puts "🚀 Para testar:"
  puts "   1. rails server"
  puts "   2. Acesse http://localhost:3000"
  puts "   3. Faça login com qualquer usuário acima"
  puts ""
  puts "🔐 FLUXO DE TESTE:"
  puts "   • Login como ADMIN → Criar/gerenciar templates"
  puts "   • Login como ALUNO → Responder templates"
  puts "="*50

else
  puts "❌ Seeds só rodam em ambiente de desenvolvimento"
  puts "   Ambiente atual: #{Rails.env}"
end
