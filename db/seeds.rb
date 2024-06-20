# frozen_string_literal: true

require 'faker'

# Constants/settings
CURRENT_YEAR = Time.now.year
YEARS = 5

# Default template questions
DEFAULT_TEMPLATES = {
  template1: [
    {
      type: 'MultipleChoiceQuestion',
      label: 'Como você avalia a clareza das explicações do professor durante as aulas?',
      format: 'Muito clara|Clara|Nem clara, nem confusa|Pouco clara|Nada clara'
    },
    {
      type: 'MultipleChoiceQuestion',
      label: 'Em sua opinião, as atividades práticas realizadas em sala de aula contribuíram para o seu aprendizado?',
      format: 'Sim, muito|Sim, um pouco|Não fizeram diferença|Não contribuíram|Não sei/não lembro'
    },
    {
      type: 'TextInputQuestion',
      label: 'O que você sugere para melhorar a clareza das explicações em sala de aula?'
    }
  ],
  template2: [
    {
      type: 'MultipleChoiceQuestion',
      label: 'Qual a sua opinião sobre a interação do professor com os alunos durante as aulas?',
      format: 'Muito interativa|Interativa|Nem interativa, nem distante|Pouco interativa|Muito distante'
    },
    {
      type: 'MultipleChoiceQuestion',
      label: 'As atividades em grupo foram úteis para o seu aprendizado?',
      format: 'Sim, muito|Sim, um pouco|Não fizeram diferença|Não foram úteis|Não sei/não lembro'
    },
    {
      type: 'TextInputQuestion',
      label: 'Como você se sente incentivado a participar das discussões em sala de aula?'
    }
  ],
  template3: [
    {
      type: 'MultipleChoiceQuestion',
      label: 'Como você avalia a organização do conteúdo programático da disciplina?',
      format: 'Muito organizado|Organizado|Nem organizado, nem desorganizado|Pouco organizado|Muito desorganizado'
    },
    {
      type: 'MultipleChoiceQuestion',
      label: 'As leituras complementares indicadas foram relevantes para o seu entendimento do tema?',
      format: 'Sim, muito|Sim, um pouco|Não fizeram diferença|Não foram relevantes|Não sei/não lembro'
    },
    {
      type: 'TextInputQuestion',
      label: 'O que você sugere para melhorar a organização do conteúdo programático da disciplina?'
    }
  ],
  template4: [
    {
      type: 'MultipleChoiceQuestion',
      label: 'Qual a sua opinião sobre a utilização de recursos tecnológicos nas aulas?',
      format: 'Muito útil|Útil|Nem útil, nem prejudicial|Prejudicial|Muito prejudicial'
    },
    {
      type: 'MultipleChoiceQuestion',
      label: 'As atividades práticas realizadas fora da sala de aula contribuíram para o seu aprendizado?',
      format: 'Sim, muito|Sim, um pouco|Não fizeram diferença|Não foram úteis|Não sei/não lembro'
    },
    {
      type: 'TextInputQuestion',
      label: 'O que você sugere para melhorar a integração de atividades práticas fora da sala de aula?'
    }
  ],
  template5: [
    {
      type: 'MultipleChoiceQuestion',
      label: 'Como você avalia a disponibilidade do professor para esclarecer dúvidas fora do horário de aula?',
      format: 'Muito disponível|Disponível|Nem disponível, nem indisponível|Indisponível|Muito indisponível'
    },
    {
      type: 'MultipleChoiceQuestion',
      label: 'As atividades extracurriculares propostas contribuíram para o seu desenvolvimento acadêmico?',
      format: 'Sim, muito|Sim, um pouco|Não fizeram diferença|Não foram úteis|Não sei/não lembro'
    },
    {
      type: 'TextInputQuestion',
      label: 'O que você sugere para melhorar a oferta de atividades extracurriculares?'
    }
  ]
}.freeze

DEFAULT_TEMPLATES.each_value do |questions|
  puts 'Creating template...'
  template = Template.create
  questions.each do |question|
    case question[:type]
    when 'MultipleChoiceQuestion'
      MultipleChoiceQuestion.create formlike: template, label: question[:label], format: question[:format]
    when 'TextInputQuestion'
      TextInputQuestion.create formlike: template, label: question[:label]
    else
      puts 'Invalid question type. Skipping...'
    end
    puts "Pergunta \"#{question[:label]}\" (#{question[:type]}) criada com sucesso"
  end
end

user_attributes = {
  email: 'coordenador@gmail.com',
  password: '$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu', # TOKEN_587
  salt: '$2a$12$9sauXRcV/alggmsRweudU.',
  created_at: Time.now,
  is_admin: true
}

# Default user
user = User.find(user_attributes[:email])

if user.nil?
  user = User.new
  user.email = user_attributes[:email]
  user.salt = user_attributes[:salt]
  user.password = user_attributes[:password]
  user.created_at = user_attributes[:created_at]
  user.is_admin = user_attributes[:is_admin]

  if user.save
    puts 'Usuário criado com sucesso!'
  else
    puts "Erro ao criar usuário: #{user.errors.full_messages.join(', ')}"
  end
else
  puts 'Usuário já existe.'
end
