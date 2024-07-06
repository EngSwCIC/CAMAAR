##
# Define a classe base abstrata para todos os modelos Active Record.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
