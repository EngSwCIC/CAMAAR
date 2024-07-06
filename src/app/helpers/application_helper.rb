##
# O módulo ApplicationHelper é destinado a fornecer métodos auxiliares para o controlador de Application.
# Métodos definidos aqui podem ser usados em views associadas ao recurso de Application para facilitar a manipulação e apresentação de dados.
module ApplicationHelper
    ##
    # Retorna o título da página com base na ação do controlador e no nome do controlador.
    #
    # +return+ [String] O título da página baseado na ação atual do controlador.
    # +effect_side+ Gera um título específico para diferentes páginas baseadas no nome da ação e no controlador.
    def current_page_title
        # Obtém o nome do controlador e a ação atual no formato "controller/action"
        view_name = "#{controller_name}/#{action_name}"
        
        # Determina o título da página com base na ação do controlador
        if view_name.include?("gerenciamento")
            return "Gerenciamento"
        elsif view_name.include?("resultados")
            return "Gerenciamento - Resultados"
        elsif view_name.include?("template")
            return "Gerenciamento - Templates"
        elsif view_name.include?("enviarFormularios")
            return "Gerenciamento - Enviar Formulários"
        else
            return "Avaliações"
        end
    end
end
