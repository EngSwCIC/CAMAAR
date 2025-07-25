#!/bin/bash
# Script para testar a criação de perguntas via web

echo "=== TESTE DE CRIAÇÃO DE PERGUNTAS ==="
echo "1. Verificando se o servidor está rodando..."
curl -s -o /dev/null http://localhost:3000 && echo "✓ Servidor OK" || echo "✗ Servidor não está rodando"

echo "2. Testando criação de pergunta diretamente no banco..."
bin/rails runner "
begin
  template = Template.first
  puts \"Template: #{template.titulo}\"
  
  before_count = template.pergunta.count
  puts \"Perguntas antes: #{before_count}\"
  
  pergunta = template.pergunta.create!(
    texto: 'Pergunta de teste #{Time.current}',
    tipo: 'subjetiva',
    obrigatoria: true
  )
  
  after_count = template.pergunta.count
  puts \"Perguntas depois: #{after_count}\"
  puts \"✓ Pergunta criada com sucesso! ID: #{pergunta.id}\"
rescue => e
  puts \"✗ Erro ao criar pergunta: #{e.message}\"
end
"

echo "3. Verificando estrutura do banco..."
bin/rails runner "
puts \"Tabelas no banco:\"
puts ActiveRecord::Base.connection.tables.sort

puts \"\\nColunas da tabela pergunta:\"
ActiveRecord::Base.connection.columns('pergunta').each do |col|
  puts \"  #{col.name}: #{col.type} (#{col.null ? 'nullable' : 'not null'})\"
end
"
