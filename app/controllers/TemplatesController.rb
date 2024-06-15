class TemplatesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def save_template
    template_data = params.require(:template).permit(:templateName, questions: [:type, { options: [] }])
    file_name = "#{template_data[:templateName]}.json"
    file_path = Rails.root.join('public', 'templates', file_name)

    File.open(file_path, 'w') do |file|
      file.write(JSON.pretty_generate(template_data.to_h))
    end

    render plain: 'Template salvo com sucesso!'
  rescue => e
    logger.error "Erro ao salvar o template: #{e.message}"
    render plain: 'Erro ao salvar o template', status: :internal_server_error
  end
end
