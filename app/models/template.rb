##
# Template de formulário de avaliação
#
# Um template é criado por administradores e contém um conjunto de perguntas
# que serão respondidas pelos usuários do sistema (docentes e discentes).
# Cada template pode ter múltiplas perguntas de diferentes tipos.
#
# === Tipos de Pergunta Suportados
# * +text+: Resposta em texto livre
# * +radio+: Múltipla escolha (uma opção)
# * +checkbox+: Múltipla escolha (várias opções)
# * +scale+: Escala numérica (1-5)
#
# === Associações
# * Pertence a um User (admin que criou o template)
# * Tem muitas TemplateQuestion (perguntas do formulário)
# * Tem muitas TemplateResponse (respostas dos usuários)
#
# === Exemplo de uso
#
#   # Criar template básico
#   admin = User.find_by(ocupacao: 'admin')
#   template = admin.templates.create!(
#     name: "Avaliação da Disciplina CIC0105",
#     description: "Formulário para avaliar a disciplina de Engenharia de Software"
#   )
#
#   # Adicionar perguntas
#   template.template_questions.create!([
#     {
#       question_text: "Como você avalia o conteúdo da disciplina?",
#       question_type: "scale",
#       required: true,
#       position: 1
#     },
#     {
#       question_text: "Deixe seus comentários:",
#       question_type: "text",
#       required: false,
#       position: 2
#     }
#   ])
#
#   # Verificar se usuário já respondeu
#   template.answered_by?(current_user)  # => false
#
class Template < ApplicationRecord
  belongs_to :user
  has_many :template_questions, dependent: :destroy
  has_many :template_responses, dependent: :destroy

  ##
  # Permite criação/edição de perguntas junto com o template
  #
  # Configuração para formulários aninhados que permite:
  # * Criar perguntas ao criar template
  # * Editar perguntas existentes
  # * Remover perguntas marcadas para exclusão
  # * Ignorar perguntas vazias automaticamente
  accepts_nested_attributes_for :template_questions,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :name, presence: true, uniqueness: true

  ##
  # Scope para templates publicados (funcionalidade futura)
  scope :published, -> { where(published: true) }

  ##
  # Conta o total de respostas recebidas para este template
  #
  # === Retorno
  # +Integer+:: Número total de usuários que responderam
  #
  # === Exemplo
  #   template = Template.find(1)
  #   puts "#{template.total_responses} usuários responderam"
  def total_responses
    template_responses.count
  end

  ##
  # Busca a resposta de um usuário específico para este template
  #
  # === Parâmetros
  # +user+:: Usuário para buscar a resposta
  #
  # === Retorno
  # +TemplateResponse+:: Resposta do usuário ou nil se não respondeu
  #
  # === Exemplo
  #   response = template.response_from_user(current_user)
  #   if response
  #     puts "Usuário respondeu em #{response.submitted_at}"
  #   end
  def response_from_user(user)
    template_responses.find_by(user: user)
  end

  ##
  # Verifica se um usuário já respondeu este template
  #
  # === Parâmetros
  # +user+:: Usuário para verificar
  #
  # === Retorno
  # +Boolean+:: true se o usuário já respondeu
  #
  # === Exemplo
  #   if template.answered_by?(current_user)
  #     # Mostrar como "Concluído"
  #   else
  #     # Mostrar botão "Responder"
  #   end
  def answered_by?(user)
    template_responses.exists?(user: user)
  end
end
