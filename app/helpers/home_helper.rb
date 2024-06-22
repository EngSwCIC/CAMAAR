module HomeHelper
  def is_gerenciamento(controller)
    ['gerenciamento', 'resultados', 'send_forms', 'templates'].include? controller
  end
end
