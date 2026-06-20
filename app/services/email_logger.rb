class EmailLogger
  LOG_DIR = Rails.root.join("notificacoes")

  def initialize(base_url: "http://localhost:3000")
    @base_url = base_url
    FileUtils.mkdir_p(LOG_DIR)
    @entries = []
  end

  def log_convite_acesso(nome:, email:, token:)
    url = "#{@base_url}/senha/nova?token=#{token}"
    @entries << build_invite_email(nome: nome, email: email, url: url)
  end

  def flush
    return nil if @entries.empty?

    path = next_log_path
    File.write(path, build_content, encoding: "UTF-8")
    path
  end

  private

  def next_log_path
    last = Dir[LOG_DIR.join("emails_disparados_*.log")]
              .filter_map { |f| File.basename(f).match(/emails_disparados_(\d+)\.log/)&.captures&.first&.to_i }
              .max || 0
    LOG_DIR.join("emails_disparados_#{last + 1}.log")
  end

  def build_content
    sep = "=" * 60
    header = <<~HEADER
      CAMAAR — Convites de Primeiro Acesso
      Gerado em: #{Time.current.strftime('%d/%m/%Y às %H:%M:%S')}
      Total de convites: #{@entries.size}

      #{sep}

    HEADER

    body = @entries.each_with_index.map do |entry, i|
      "[#{i + 1}/#{@entries.size}]\n#{entry}"
    end.join("\n#{sep}\n\n")

    header + body
  end

  def build_invite_email(nome:, email:, url:)
    <<~EMAIL
      Para:    #{email}
      Assunto: Bem-vindo ao CAMAAR — Defina sua senha de acesso

      Olá, #{nome}!

      Você foi cadastrado no sistema CAMAAR da Universidade de Brasília.

      Para ativar sua conta e definir sua senha, acesse o link abaixo:

        #{url}

      Este link é válido por 48 horas. Após definir sua senha, você
      poderá acessar o sistema normalmente.

      Se você não esperava este email, entre em contato com a coordenação.

      Atenciosamente,
      Equipe CAMAAR — Universidade de Brasília

    EMAIL
  end
end
