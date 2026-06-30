# Be sure to restart your server when you modify this file.

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "questao", "questoes"
  inflect.irregular "resposta", "respostas"
  inflect.irregular "resposta_questao", "resposta_questoes"
  inflect.irregular "turma_formulario", "turma_formularios"
  inflect.irregular "formulario", "formularios"
end
