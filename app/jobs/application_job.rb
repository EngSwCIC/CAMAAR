## Classe padrão para os jobs do rails
##
# === Descrição
# Classe base para os jobs assincronos do rails
# === Argumentos
# * Nenhum.
# === Retorno
# * +nil+
# === Efeitos Colaterais
# * Nenhum.
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
