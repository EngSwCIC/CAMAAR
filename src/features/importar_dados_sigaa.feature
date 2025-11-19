# language: pt
# features/importar_dados_sigaa.feature

Funcionalidade: Importar novos dados do SIGAA
  Eu como Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
  A fim de alimentar a base de dados do sistema.

  Contexto:
    Dado que eu estou logado como Administrador
    E estou na página "Gerenciamento"

  @happy_path
  Cenário: Importação inicial de turma e participante na turma com sucesso
    Dado que o sistema não possui nenhuma turma cadastrada
    E que o sistema não possui nenhum usuário cadastrado
    E que o sigaa contém a turma "BANCOS DE DADOS" (CIC0097)
    E esta turma contém o participante "Fulano de Tal" (150084006)
    Quando eu clico no botão "Importar dados"
    Então a turma "BANCOS DE DADOS" (CIC0097) deve ser cadastrada no sistema
    E o usuário "Fulano de Tal" (150084006) deve ser cadastrado no sistema
    E o usuário "Fulano de Tal" deve estar matriculado na turma "BANCOS DE DADOS"
    E eu devo ver a mensagem de sucesso "Dados importados com sucesso!"

  @happy_path
  Cenário: Importação de nova turma e participante já existente na turma com sucesso
    Dado que o sistema possui o usuário "Ciclano de Tal" (150084007) cadastrado
    E que o sistema não possui a turma "ESTRUTURA DE DADOS" (CIC0002) cadastrada
    E que o sigaa contém a turma "ESTRUTURA DE DADOS" (CIC0002)
    E esta turma contém o participante "Ciclano de Tal" (150084007)
    Quando eu clico no botão "Importar dados"
    Então a turma "ESTRUTURA DE DADOS" (CIC0002) deve ser cadastrada no sistema
    E o usuário "Ciclano de Tal" deve estar matriculado na turma "ESTRUTURA DE DADOS" (CIC0002)
    E eu devo ver a mensagem de sucesso "Dados importados com sucesso!"

  @happy_path
  Cenário: Importação de turma já existente e novo participante na turma com sucesso
    Dado que o sistema possui a turma "ALGORITMOS E PROGRAMAÇÃO" (CIC0001) cadastrada
    E que o sistema não possui o usuário "Beltrano de Tal" (150084008) cadastrado
    E esta turma contém o participante "Beltrano de Tal" (150084008)
    Quando eu clico no botão "Importar dados"
    Então o usuário "Beltrano de Tal" (150084008) deve ser cadastrado no sistema
    E o usuário "Beltrano de Tal" deve estar matriculado na turma "ALGORITMOS E PROGRAMAÇÃO" (CIC0001)
    E eu devo ver a mensagem de sucesso "Dados importados com sucesso!"

  @happy_path
  Cenário: Importação sem duplicação de um usuário já existente
    Dado que o sistema possui o usuário "Fulano de Tal" (150084006) cadastrado
    E que o sigaa contém a turma "REDES DE COMPUTADORES" (CIC0003)
    E esta turma contém o participante "Fulano de Tal" (150084006)
    Quando eu clico no botão "Importar dados"
    Então o usuário "Fulano de Tal" (150084006) não deve ser duplicado no sistema
    E o usuário "Fulano de Tal" deve estar matriculado na turma "REDES DE COMPUTADORES" (CIC0003)
    E eu devo ver a mensagem de sucesso "Dados importados com sucesso!"

  @sad_path
  Cenário: Falha ao buscar os dados externos
    Dado que o sigaa está indisponível
    Quando eu clico no botão "Importar dados"
    Então eu devo ver a mensagem de erro "Não foi possível buscar os dados. Tente novamente mais tarde."
    E nenhuma nova turma deve ser cadastrada no sistema
    E nenhum novo usuário deve ser cadastrado no sistema