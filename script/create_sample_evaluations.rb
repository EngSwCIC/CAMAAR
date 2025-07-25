# Script para criar dados de exemplo para testar o sistema de avaliações

# Buscar um template existente
template = Template.first

if template.nil?
  puts '❌ Nenhum template encontrado. Crie um template primeiro.'
  exit
end

# Buscar um usuário admin
admin = User.admin.first

if admin.nil?
  puts '❌ Nenhum usuário admin encontrado.'
  exit
end

# Buscar uma disciplina
disciplina = Disciplina.first

# Criar um formulário para todos os usuários
formulario_todos = Formulario.create!(
  template: template,
  coordenador: admin,
  data_envio: 1.day.ago,
  data_fim: 1.week.from_now,
  ativo: true,
  escopo_visibilidade: :todos
)

puts "✅ Formulário criado para todos os usuários: #{formulario_todos.id}"

# Criar um formulário específico para uma disciplina (se existir)
if disciplina
  formulario_disciplina = Formulario.create!(
    template: template,
    coordenador: admin,
    disciplina: disciplina,
    data_envio: 1.day.ago,
    data_fim: 1.week.from_now,
    ativo: true,
    escopo_visibilidade: :por_disciplina
  )

  puts "✅ Formulário criado para disciplina #{disciplina.nome}: #{formulario_disciplina.id}"
end

puts '🎉 Dados de exemplo criados com sucesso!'
puts '🔗 Acesse /evaluations para ver os formulários disponíveis'
