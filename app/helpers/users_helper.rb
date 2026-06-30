#:nodoc:
module UsersHelper
  # Usuário convidado que ainda não aceitou o convite aparece como pendente;
  # demais (com senha definida) aparecem como ativos.
  def status_do_usuario(user)
    if user.respond_to?(:invitation_sent_at) && user.invitation_sent_at.present? && !user.invitation_accepted?
      "Pendente (Aguardando acesso)"
    else
      "Ativo"
    end
  end
end
