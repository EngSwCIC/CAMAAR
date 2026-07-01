# frozen_string_literal: true

# Regras de acesso a formulários por departamento.
#
# Administradores só acessam formulários cuja turma pertence ao departamento do
# perfil logado.
class FormularioPolicy < ApplicationPolicy
  # Escopo de formulários visíveis ao usuário autenticado.
  class Scope < ApplicationPolicy::Scope
    ##
    # Restringe a relação de formulários ao departamento do administrador.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +scope+ e o usuário fornecidos pela policy.
    #
    # Retorno:
    # - Formulários do departamento quando o usuário é administrador.
    # - Relação vazia para demais perfis.
    #
    # Efeitos colaterais:
    # - Não altera o banco de dados.
    # - Retorna uma relação que pode consultar o banco quando materializada.
    def resolve
      return scope.do_departamento(current_administrador.departamento) if administrador?

      scope.none
    end
  end

  ##
  # Permite listar formulários.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa o usuário autenticado da policy.
  #
  # Retorno:
  # - +true+ quando o usuário é administrador.
  # - +false+ caso contrário.
  #
  # Efeitos colaterais:
  # - Não consulta nem altera o banco de dados.
  def index?
    administrador?
  end

  ##
  # Permite visualizar um formulário específico.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa o +record+ associado à policy.
  #
  # Retorno:
  # - +true+ quando o formulário pertence ao departamento do administrador.
  # - +false+ caso contrário.
  #
  # Efeitos colaterais:
  # - Não altera o banco de dados.
  def show?
    formulario_do_departamento?
  end

  ##
  # Permite exibir o formulário de publicação.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa o usuário autenticado da policy.
  #
  # Retorno:
  # - Mesmo critério de +create?+.
  #
  # Efeitos colaterais:
  # - Não consulta nem altera o banco de dados.
  def new?
    create?
  end

  ##
  # Permite criar formulários.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa o usuário autenticado da policy.
  #
  # Retorno:
  # - +true+ quando o usuário é administrador.
  # - +false+ caso contrário.
  #
  # Efeitos colaterais:
  # - Não consulta nem altera o banco de dados.
  def create?
    administrador?
  end

  ##
  # Permite exportar respostas do formulário em CSV.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa o +record+ associado à policy.
  #
  # Retorno:
  # - Mesmo critério de +show?+.
  #
  # Efeitos colaterais:
  # - Não altera o banco de dados.
  def exportar_csv?
    show?
  end

  private

  ##
  # Verifica se o registro autorizado pertence ao departamento do administrador.
  #
  # Quando +record+ é a classe +Formulario+ (autorização genérica em +index+ ou
  # +create+), retorna +true+ para administradores sem comparar departamento.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa +record+ e o administrador autenticado.
  #
  # Retorno:
  # - +false+ para não-administradores.
  # - +true+ quando +record+ é a classe ou a turma do formulário pertence ao
  #   departamento do administrador logado.
  #
  # Efeitos colaterais:
  # - Não altera o banco de dados.
  def formulario_do_departamento?
    return false unless administrador?
    return true if record.is_a?(Class)

    record.turma.departamento_id == current_administrador.departamento_id
  end
end
