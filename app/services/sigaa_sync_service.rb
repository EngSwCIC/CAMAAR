class SigaaSyncService
  def initialize(user)
    @user = user
  end

  def call
    return failure("Acesso negado") unless @user.admin?
    return failure("Já existe uma atualização em andamento") if SyncLock.active?

    SyncLock.start!

    begin
      json = SigaaApi.fetch_data

      return failure("SIGAA não retornou dados") if json.nil? || json.strip == "[]"

      classes = SigaaImporter.import_classes(json)
      members = SigaaImporter.import_members(json)

      return failure("SIGAA retornou dados inconsistentes") unless classes[:success] && members[:success]

      SigaaLog.create!(
        user: @user,
        status: "success",
        message: "Atualização SIGAA concluída"
      )

      success("Atualização concluída com sucesso")

    rescue => e
      SigaaLog.create!(
        user: @user,
        status: "error",
        message: e.message
      )

      failure(e.message)

    ensure
      SyncLock.release!
    end
  end

  private

  def success(msg)
    { success: true, message: msg }
  end

  def failure(msg)
    { success: false, message: msg }
  end
end