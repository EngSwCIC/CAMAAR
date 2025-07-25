#!/bin/bash
# Script para testar se os modelos estão funcionando corretamente

echo "Testando os modelos após as alterações..."

# Testa se os modelos carregam sem erro
bin/rails runner "
begin
  puts 'Testando Template...'
  Template.first || puts('Template OK')
  
  puts 'Testando Perguntum...'
  Perguntum.first || puts('Perguntum OK')
  
  puts 'Testando Formulario...'
  Formulario.first || puts('Formulario OK')
  
  puts 'Testando User...'
  User.first || puts('User OK')
  
  puts 'Testando SubmissaoConcluida...'
  SubmissaoConcluida.first || puts('SubmissaoConcluida OK')
  
  puts 'Todos os modelos carregaram corretamente!'
rescue => e
  puts \"ERRO: #{e.message}\"
  puts e.backtrace.first(5)
end
"
