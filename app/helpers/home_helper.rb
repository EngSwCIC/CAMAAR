module HomeHelper
  def is_gerenciamento(controller)
    ['gerenciamento', 'resultados'].include? controller
  end
end
