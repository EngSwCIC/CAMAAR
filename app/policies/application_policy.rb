# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :usuario, :record

  def initialize(usuario, record)
    @usuario = usuario
    @record = record
  end

  def self.scope(usuario, scope)
    const_get(:Scope).new(usuario, scope).resolve
  end

  def administrador?
    usuario&.administrador?
  end

  def current_administrador
    usuario&.perfil_adm
  end

  class Scope
    attr_reader :usuario, :scope

    def initialize(usuario, scope)
      @usuario = usuario
      @scope = scope
    end

    def resolve
      scope.none
    end
  end
end
