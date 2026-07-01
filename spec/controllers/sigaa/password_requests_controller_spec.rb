# frozen_string_literal: true

require "rails_helper"

RSpec.describe SIGAA::PasswordRequestsController, type: :controller do
  before do
    routes.draw do
      post "password_requests", to: "sigaa/password_requests#create"
      get "gerenciamento", to: "dashboard#gerenciamento", as: :gerenciamento
      root "auth#index"
    end

    stub_const("PasswordRequestService", Class.new)
    allow(controller).to receive(:require_administrador!).and_return(true)
  end

  after do
    Rails.application.reload_routes!
  end
  it "redireciona com notice quando o serviço tem sucesso" do
    result = instance_double("PasswordRequestResult", success?: true, message: "Solicitações enviadas")
    service = instance_double("PasswordRequestService", call: result)
    allow(PasswordRequestService).to receive(:new).and_return(service)

    post :create

    expect(response).to redirect_to(gerenciamento_path)
    expect(flash[:notice]).to eq("Solicitações enviadas")
  end

  it "redireciona com alert quando o serviço falha" do
    result = instance_double("PasswordRequestResult", success?: false, message: "Falha no envio")
    service = instance_double("PasswordRequestService", call: result)
    allow(PasswordRequestService).to receive(:new).and_return(service)

    post :create

    expect(response).to redirect_to(gerenciamento_path)
    expect(flash[:alert]).to eq("Falha no envio")
  end
end
