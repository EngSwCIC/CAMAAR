# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:

Tipo.create([
  { nome: 'confirmação', numeroDeAlternativas: 1, discursiva?: false},
  { nome: 'satisfação', numeroDeAlternativas: 5, discursiva?: false},
  { nome: 'múltipla escolha', numeroDeAlternativas: 4, discursiva?: false },
  { nome: 'discursiva', numeroDeAlternativas: 0, discursiva?: true}
])

Disciplina.create!(
  nome: 'Introdução ao Cálculo',
  codigo: 'MAT001'
)

usuarios = [
  {nome: "fulano",
  email: "exemplo@unb.br",
  password: 'senha123',
  usuario: "000001",
  formacao: "graduando",
  role: :dicente},

  {nome: "administrador",
  email: "adm@unb.br",
  password: 'o_pai_ta_on_123',
  usuario: "83807519491",
  formacao: "DOUTORADO",
  role: :docente}
]

usuarios.each do |user_data|
  user = User.create!(
    nome: user_data[:nome],
    email: user_data[:email],
    password: user_data[:password],
    usuario: user_data[:usuario],
    formacao: user_data[:formacao],
    role: user_data[:role]
  )

  if user.docente?
    Docente.create!(
      user_id: user.id,
      departamento: "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
    )
  elsif user.dicente?
    Dicente.create!(
      user_id: user.id,
      curso: "CIÊNCIAS DA COMPUTAÇÃO",
      matricula: "000001"
    )
  end
end

  Dicente.find_by(user_id: User.find_by(nome: "fulano"))

  turma1 = Turma.create!(
    semestre: '2024.2',
    horario: '24M12',
    class_code: 'TA',
    codigo: 'MAT001',
    disciplina: Disciplina.find_by(nome: "Introdução ao Cálculo"),
    docente: Docente.find_by(user_id: User.find_by(nome: "administrador").id)
  )

  fulano = Dicente.find_by(user_id: User.find_by(nome: "fulano").id)

  fulano.turmas << turma1
  turma1.dicentes << fulano

  template1 = Template.create!(
    nome: 'Satisfação de Calculo 1',
    docente_id: Docente.find_by(user_id: User.find_by(nome: "administrador").id).id,
    questaos_attributes: [

    ]
  )

  provasDerivadas = Formulario.find_or_create_by(
    nome: 'Prova de Derivadas',
    docente_id: Docente.find_by(user_id: User.find_by(nome: "administrador")).id,
    turma_id: formularios_classe.classe_id,
    template_id: template1.id,
    dataDeTermino: Date.new(2024, 7, 1)
  )
  provaDerivadas.classes << Calculo1

  post 'Seed percorrida com sucesso'
