require 'rails_helper'

RSpec.describe "Templates", type: :controller do
  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        { post: { codigo: 't3mp23#', id_usuario: 1, nome:  } }
      end

      it "create a template" do
        post :index
        expect(response)
      end
    end
end
