require 'rails_helper'

class String
    # Método checa se todos os characteres de uma string são números.
    def is_integer?
        self.to_i.to_s == self
    end
end

RSpec.describe ValidateController, :type => :controller do
    describe "testa gerarCodigo" do
        before(:each) {
            @validation = ValidateController.new()
            @validation.gerarCodigo()

            # Como a variável é de classe, ela deve ser acessada dessa forma
            # Foi armazenada em @codigoTeste para melhorar legibilidade
            @codigoTeste = ValidateController.class_variable_get(:@@codigo)
        }

        it 'tem 5 digitos' do
            expect(@codigoTeste.length).to eq(5)
        end

        it 'todos os digitos sao numeros' do
            expect(@codigoTeste.is_integer?).to eq(true)
        end
    end

    describe "testa comparaCodigo" do
        before(:each) {
            @validation = ValidateController.new()
            @validation.gerarCodigo()

            @codigoTeste = ValidateController.class_variable_get(:@@codigo)
            # String aleatória de 5 dígitos para comparação.
            @codigoCompara = '%05d' % rand(10 ** 5)
        }

        it 'comparando codigos' do
            # A possibilidade que ambos os códigos sejam iguais é muito baixa
            # É esperado que a comparação resulte em false
            expect(@codigoTeste.eql?(@codigoCompara)).to eq(false)
        end
    end
end
			