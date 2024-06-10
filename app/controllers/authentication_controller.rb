class AuthenticationController < ApplicationController
    def new
      render 'login'
    end
end