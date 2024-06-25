class UserSerializer < Panko::Serializer
  attributes :id, :nome, :email, :curso, :matricula, :formacao, :ocupacao, :role
end
