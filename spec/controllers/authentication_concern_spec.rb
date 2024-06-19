# spec/controllers/authentication_concern_spec.rb

require 'rails_helper'

class DummyController < ApplicationController
  include AuthenticationConcern
end

RSpec.describe DummyController, type: :controller do
  controller do
    def index
      if user_authenticated
        render plain: "Authenticated"
      else
        render plain: "Not Authenticated"
      end
    end
  end

  describe "user_authenticated" do
    let!(:user) { User.create(email: "t@gmail.com", salt: "$2a$12$9sauXRcV/alggmsRweudU.", password: "$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu", session_key: "T") }

    context "with valid session" do
      before do
        timestamp = 59.minutes.ago.to_i
        cookies.signed[:user_info] = "T_#{timestamp}_t@gmail.com"
      end

      it "returns true and renders Authenticated" do
        get :index
        expect(response.body).to eq("Authenticated")
      end
    end

    context "with expired session" do
      before do
        timestamp = 2.hours.ago.to_i
        cookies.signed[:user_info] = "T_#{timestamp}_t@gmail.com"
      end

      it "returns false and renders Not Authenticated" do
        get :index
        expect(response.body).to eq("Not Authenticated")
        expect(cookies[:user_info]).to be_nil
      end
    end

    context "with invalid session key" do
      before do
        timestamp = 10.minutes.ago.to_i
        cookies.signed[:user_info] = "INVALID_#{timestamp}_t@gmail.com"
      end

      it "returns false and renders Not Authenticated" do
        get :index
        expect(response.body).to eq("Not Authenticated")
        expect(cookies[:user_info]).to be_nil
      end
    end

    context "with missing user info" do
      before do
        cookies.signed[:user_info] = nil
      end

      it "returns false and renders Not Authenticated" do
        get :index
        expect(response.body).to eq("Not Authenticated")
      end
    end
  end
end
