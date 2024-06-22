class HomeController < ApplicationController

  def index
    # This controller action is responsible for providing data to the view
    # For now, we'll just define some dummy data
    @materia = [
      { codigo: "MAT-101", nome: "Introduction to Programming" },
      { codigo: "MAT-202", nome: "Calculus I" },
      { codigo: "MAT-303", nome: "Linear Algebra" }
    ]
  end
end
