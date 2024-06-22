module ApplicationHelper
    def current_page_title
        view_name = "#{controller_name}/#{action_name}"
        
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
