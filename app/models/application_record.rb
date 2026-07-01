# Classe base abstrata para todos os models da aplicação.
# Herda de ActiveRecord::Base e centraliza configurações globais de ORM.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
