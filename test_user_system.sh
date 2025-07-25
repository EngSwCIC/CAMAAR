#!/bin/bash

echo "🧪 Executando testes do sistema de gerenciamento de usuários..."
echo "=================================================="

# Executar testes do modelo User
echo "📝 Testando modelo User..."
bundle exec rspec spec/models/user_spec.rb --format progress

# Executar testes de integração
echo "🔗 Testando integração do sistema..."
bundle exec rspec spec/integration/user_management_system_spec.rb --format progress

# Executar ambos com relatório detalhado
echo "📊 Relatório completo..."
bundle exec rspec spec/models/user_spec.rb spec/integration/user_management_system_spec.rb --format documentation

echo "=================================================="
echo "✅ Testes do sistema de usuários concluídos!"
