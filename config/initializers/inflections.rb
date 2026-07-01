# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  # Palavras simples em português usadas no domínio
  inflect.irregular "perfil", "perfis"
  inflect.irregular "questao", "questoes"
  inflect.irregular "opcao", "opcoes"
  inflect.irregular "avaliacao", "avaliacoes"
  inflect.irregular "participacao", "participacoes"
  inflect.irregular "utilizacao", "utilizacoes"

  # Palavras que o Rails até pluralizaria com "s",
  # mas ficam explícitas para evitar comportamento estranho em nomes compostos.
  inflect.irregular "usuario", "usuarios"
  inflect.irregular "departamento", "departamentos"
  inflect.irregular "materia", "materias"
  inflect.irregular "turma", "turmas"
  inflect.irregular "template", "templates"
  inflect.irregular "formulario", "formularios"
  inflect.irregular "resposta", "respostas"
  inflect.irregular "texto", "textos"

  # Nomes compostos das models do sistema
  inflect.irregular "perfil_adm", "perfis_adm"
  inflect.irregular "perfil_docente", "perfis_docentes"
  inflect.irregular "perfil_discente", "perfis_discentes"

  inflect.irregular "participacao_turma", "participacoes_turmas"
  inflect.irregular "utilizacao_questao", "utilizacoes_questoes"
  inflect.irregular "opcao_escolhida", "opcoes_escolhidas"

  # Siglas úteis, caso apareçam em nomes de classes no projeto
  inflect.acronym "SIGAA"
  inflect.acronym "CSV"
end
