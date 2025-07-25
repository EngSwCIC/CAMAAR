#!/bin/bash

# Script para aplicar mocking pattern em controllers

controllers=(
  "disciplinas_controller_spec.rb"
  "evaluations_controller_spec.rb" 
  "minhas_disciplinas_controller_spec.rb"
  "pergunta_controller_spec.rb"
  "primeira_senha_controller_spec.rb"
  "recuperar_senha_controller_spec.rb"
  "reports_controller_spec.rb"
  "turmas_controller_spec.rb"
  "users_controller_spec.rb"
)

for controller in "${controllers[@]}"; do
  echo "Processing $controller..."
  
  # Replace sign_in with mocking pattern
  sed -i 's/before { sign_in \([^}]*\) }/before do\
    allow(controller).to receive(:authenticate_user!).and_return(true)\
    allow(controller).to receive(:current_user).and_return(\1)\
  end/g' "spec/controllers/$controller"
  
  # Add global before block if not exists
  if ! grep -q "allow(controller).to receive(:authenticate_user!)" "spec/controllers/$controller"; then
    sed -i '/^RSpec.describe.*type: :controller do$/a\
  before do\
    allow(controller).to receive(:authenticate_user!).and_return(true)\
  end\
' "spec/controllers/$controller"
  fi
done

echo "Done applying mocking pattern to all controllers"
