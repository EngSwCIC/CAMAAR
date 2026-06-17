module ApplicationHelper
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
