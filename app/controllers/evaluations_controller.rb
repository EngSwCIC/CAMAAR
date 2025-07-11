# frozen_string_literal: true

class EvaluationsController < ApplicationController
  def index
    # No futuro, você buscaria isso do banco de dados, ex: @subjects = Subject.all
    # Por enquanto, vamos usar dados de exemplo.
    @subjects = [
      { name: 'Cálculo 1', semester: '2024.1', professor: 'Maria da Silva' },
      { name: 'Física Básica', semester: '2024.1', professor: 'João Pereira' },
      { name: 'Algoritmos e Estrutura de Dados', semester: '2024.1', professor: 'Ana Costa' },
      { name: 'Introdução à Engenharia', semester: '2024.1', professor: 'Carlos Souza' },
      { name: 'Química Geral', semester: '2024.1', professor: 'Beatriz Lima' }
    ]
  end
end
