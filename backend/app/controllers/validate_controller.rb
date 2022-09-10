class ValidateController < ApplicationController
    attr_accessor :codigo

    # Codigo deve ser global pois é gerada em show e checada em index.
    @@codigo = 0

    def show
        gerarCodigo()
        render json: {
            codigo: @@codigo
        }
    end

    def index
        # Parsing do json recebido da view
        params = request.body.read
        resultado = JSON.parse(params)

        # Recebe codigo de input da view
        codigoInput = resultado['codigoInput']
        compararCodigo(codigoInput)
    end

    def gerarCodigo
        # Gera string com 5 inteiros.
        @@codigo = '%05d' % rand(10 ** 5)
    end

    def compararCodigo(codigoInput)
        if codigoInput.eql?(@@codigo)
                render json: {
                status: "Codigo correto"
            }
        else
            render json: {
                status: "Codigo incorreto"
            }
        end
    end
end
