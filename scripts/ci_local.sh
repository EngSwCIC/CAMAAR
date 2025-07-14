#!/bin/bash

# Script para executar CI localmente
set -e

echo "🚀 Executando CI local para CAMAAR..."
echo

# Criar diretório tmp se não existir
mkdir -p tmp

echo "📋 1. Executando RuboCop..."
bundle exec rubocop --format github
bundle exec rubocop --format json --out tmp/rubocop_results.json

echo
echo "🧪 2. Executando RSpec..."
bundle exec rspec --format progress --format RspecJunitFormatter --out tmp/rspec_results.xml

echo
echo "🔒 3. Executando Brakeman (verificação de segurança)..."
bundle exec brakeman --format json --output tmp/brakeman_results.json

echo
echo "✅ CI local executado com sucesso!"
echo "📊 Relatórios gerados em tmp/:"
ls -la tmp/

echo
echo "🎯 Para ver detalhes dos relatórios:"
echo "  - RuboCop: cat tmp/rubocop_results.json | jq"
echo "  - RSpec: cat tmp/rspec_results.xml"
echo "  - Brakeman: cat tmp/brakeman_results.json | jq"
