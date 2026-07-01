##
# Classe base abstrata dos modelos persistidos pelo Active Record.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
