class CclassesController < ApplicationController
    def index
      @classes = Cclass.all
      render json: @classes, status: :ok
    end
  
    def show
      @cclass = Cclass.find(params[:id])
      render json: @cclass, status: :ok
    end
  end