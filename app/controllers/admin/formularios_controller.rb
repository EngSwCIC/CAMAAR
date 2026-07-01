# Gerencia a criação e vinculação de formulários de avaliação às turmas,
# na área administrativa.
class Admin::FormulariosController < Admin::BaseController
  # Exibe o formulário para criar uma nova avaliação.
  #
  # Efeito colateral: carrega +@templates+ com todos os templates disponíveis
  # e +@turmas+ filtradas pelo departamento do admin (ou todas, se não houver
  # restrição de departamento).
  def new
    @templates = Template.all
    @turmas = if departamento_admin.present?
                Turma.includes(:disciplina, :docente).joins(:docente).where(docentes: { departamento: departamento_admin })
              else
                Turma.includes(:disciplina, :docente).all
              end
  end

  # Processa a criação de formulários para um conjunto de turmas.
  #
  # Parâmetros: +:template_id+ e +:turma_ids+ (Array de IDs) via params.
  # Efeito colateral: cria um +Formulario+ e suas +Questoes+ (copiadas do
  # template) para cada turma selecionada, dentro de uma transação. Redireciona
  # para +admin_root_path+ em caso de sucesso ou para o formulário de criação
  # com alerta em caso de falha.
  def create
    turmas_ids = params[:turma_ids]
    template = template_valido(turmas_ids)
    return unless template

    criar_formularios_para_turmas(turmas_ids, template)
    redirect_to admin_root_path, notice: "Formulário criado e vinculado às turmas com sucesso."
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Ocorreu um erro ao gerar os formulários: #{e.message}"
    redirect_to new_admin_formulario_path
  end

  private

  # Retorna o departamento do docente admin, ou +nil+ se não houver.
  #
  # Retorno: String com o nome do departamento, ou +nil+.
  def departamento_admin
    current_pessoa.docente&.departamento
  end

  # Valida template e turmas em sequência; redireciona e retorna +nil+ no
  # primeiro erro encontrado, ou o +Template+ válido em caso de sucesso.
  #
  # Parâmetros: +turmas_ids+ — Array de IDs das turmas selecionadas.
  # Retorno: instância de +Template+ válida ou +nil+.
  def template_valido(turmas_ids)
    return redirect_sem_template && nil if params[:template_id].blank?

    template = Template.find(params[:template_id])
    return redirect_sem_questoes && nil if template.template_questoes.empty?
    return redirect_sem_turmas && nil if turmas_ids.blank?
    return redirect_turmas_nao_autorizadas && nil if turmas_invalidas?(turmas_ids)

    template
  end

  # Verifica se alguma das turmas selecionadas pertence a departamento
  # diferente do admin.
  #
  # Parâmetros: +turmas_ids+ — Array de IDs.
  # Retorno: +true+ se houver turmas não autorizadas, +false+ caso contrário
  # ou se o admin não tiver departamento.
  def turmas_invalidas?(turmas_ids)
    return false unless departamento_admin.present?

    Turma.joins(:docente).where(id: turmas_ids).where.not(docentes: { departamento: departamento_admin }).any?
  end

  # Cria formulários e questões para cada turma dentro de uma transação.
  #
  # Parâmetros: +turmas_ids+ — Array de IDs; +template+ — instância de
  # +Template+ com questões pré-carregadas.
  # Efeito colateral: insere registros de +Formulario+ e +Questao+ no banco.
  def criar_formularios_para_turmas(turmas_ids, template)
    ActiveRecord::Base.transaction do
      turmas_ids.each do |turma_id|
        formulario = Formulario.create!(turma_id: turma_id, template: template, status: :aberto)
        template.template_questoes.each do |tq|
          formulario.questoes.create!(enunciado: tq.enunciado, tipo_resposta: tq.tipo_resposta, opcoes: tq.opcoes)
        end
      end
    end
  end

  # Redireciona para criação de formulário com alerta de template ausente.
  #
  # Efeito colateral: define +flash[:alert]+ e redireciona para
  # +new_admin_formulario_path+.
  def redirect_sem_template
    flash[:alert] = "Obrigatório: O formulário deve ser baseado em um template existente."
    redirect_to new_admin_formulario_path
  end

  # Redireciona com alerta quando o template não possui questões.
  #
  # Efeito colateral: define +flash[:alert]+ e redireciona para
  # +new_admin_formulario_path+.
  def redirect_sem_questoes
    flash[:alert] = "O formulário precisa ter ao menos uma pergunta antes de ser publicado."
    redirect_to new_admin_formulario_path
  end

  # Redireciona com alerta quando nenhuma turma foi selecionada.
  #
  # Efeito colateral: define +flash[:alert]+ e redireciona para
  # +new_admin_formulario_path+.
  def redirect_sem_turmas
    flash[:alert] = "Você precisa selecionar pelo menos uma turma."
    redirect_to new_admin_formulario_path
  end

  # Redireciona com alerta de acesso negado por turmas de outro departamento.
  #
  # Efeito colateral: define +flash[:alert]+ e redireciona para
  # +admin_root_path+.
  def redirect_turmas_nao_autorizadas
    flash[:alert] = "Acesso negado: Você tem permissão para gerenciar apenas as turmas vinculadas ao seu departamento."
    redirect_to admin_root_path
  end
end
