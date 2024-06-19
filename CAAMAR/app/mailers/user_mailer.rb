class UserMailer < ApplicationMailer
    default from: "henriqueramos.qs@gmail.com"
    def gen_password
        print("rodou essa funcao")
        # print(params)
        print("user receiver:",params)
        print("user receiver:",params[:email])
        mail(to: params[:email],subject: "Gere sua senha do CAAMAR!")
    end
end
