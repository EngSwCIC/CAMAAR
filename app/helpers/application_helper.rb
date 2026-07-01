module ApplicationHelper
  # Renderiza um ícone SVG inline a partir de um arquivo na pasta de assets.
  #
  # @param name [String] nome do arquivo SVG sem extensão (ex.: "check", "trash")
  # @param options [Hash] atributos HTML adicionais a serem aplicados ao elemento
  #   +<span>+ envolvente (ex.: <tt>class:</tt>, <tt>id:</tt>, <tt>data:</tt>)
  # @return [ActiveSupport::SafeBuffer] elemento +<span>+ contendo o SVG inline;
  #   ou a string <tt>"(ícone não encontrado)"</tt> caso o arquivo não exista
  def svg_icon(name, options = {})
    file_path = Rails.root.join("app", "assets", "images", "icons", "#{name}.svg")
    if File.exist?(file_path)
      svg = File.read(file_path).html_safe
      content_tag(:span, svg, options.merge(class: "icon-wrapper #{options[:class]}"))
    else
      "(ícone não encontrado)"
    end
  end
end
