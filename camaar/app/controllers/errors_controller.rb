class ErrorsController < ApplicationController
  def forbidden
    render 'errors/forbidden'
  end
end
