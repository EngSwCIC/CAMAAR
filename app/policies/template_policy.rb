# frozen_string_literal: true

# Define as permissões de acesso para templates.
#
# A política permite que administradores vejam templates e restringe alterações
# destrutivas ao administrador dono do template.
class TemplatePolicy < ApplicationPolicy
  # Define quais templates ficam visíveis para o usuário atual.
  class Scope < ApplicationPolicy::Scope
    ##
    # Resolve o escopo de templates autorizado.
    #
    # Argumentos:
    # - Não recebe argumentos explicitamente. Usa +usuario+ e +scope+
    #   fornecidos ao construir o escopo da policy.
    #
    # Retorno:
    # - Retorna +scope.all+ para administradores.
    # - Retorna +scope.none+ para usuários não administradores ou anônimos.
    #
    # Efeitos colaterais:
    # - Não altera o banco de dados.
    # - Pode gerar consulta ao banco quando a relação retornada for avaliada.
    def resolve
      return scope.all if usuario&.administrador?

      scope.none
    end
  end

  ##
  # Autoriza acesso à listagem de templates.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna +true+ para administradores.
  # - Retorna +false+ para demais usuários.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def index?
    administrador?
  end

  ##
  # Autoriza visualização de um template.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna +true+ para administradores.
  # - Retorna +false+ para demais usuários.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def show?
    administrador?
  end

  ##
  # Autoriza acesso à tela de criação de template.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna o mesmo resultado de +create?+.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def new?
    create?
  end

  ##
  # Autoriza criação de templates.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna +true+ para administradores.
  # - Retorna +false+ para demais usuários.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def create?
    administrador?
  end

  ##
  # Autoriza acesso à tela de edição de template.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna o mesmo resultado de +update?+.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def edit?
    update?
  end

  ##
  # Autoriza alteração de um template.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa +record+ e o usuário da policy.
  #
  # Retorno:
  # - Retorna +true+ quando o usuário é administrador e dono do template.
  # - Retorna +false+ nos demais casos.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def update?
    dono_do_template?
  end

  ##
  # Autoriza exclusão de um template.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa +record+ e o usuário da policy.
  #
  # Retorno:
  # - Retorna +true+ quando o usuário é administrador e dono do template.
  # - Retorna +false+ nos demais casos.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def destroy?
    dono_do_template?
  end

  ##
  # Autoriza o uso de um template para preparar formulário.
  #
  # Argumentos:
  # - Não recebe argumentos.
  #
  # Retorno:
  # - Retorna +true+ para administradores.
  # - Retorna +false+ para demais usuários.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def use?
    administrador?
  end

  private

  ##
  # Verifica se o usuário atual é dono do template avaliado.
  #
  # Argumentos:
  # - Não recebe argumentos. Usa +record+ e +current_administrador+.
  #
  # Retorno:
  # - Retorna +true+ quando o usuário é administrador e criou o template.
  # - Retorna +false+ nos demais casos.
  #
  # Efeitos colaterais:
  # - Não altera estado nem persiste dados.
  def dono_do_template?
    administrador? && record.criado_por?(current_administrador)
  end
end
