# spec/controllers/home_controller_spec.rb

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "#logout" do
    controller do
      def index
        render plain: "index action"
      end
    end

    context "when admin is signed in" do
      it "logs out the admin" do
        admin = create(:admin,:admin1)  # Replace with your admin creation method
        sign_in admin

        expect(controller).to receive(:admin_signed_in?).and_return(true)
        expect(controller).to receive(:current_admin).and_return(admin)
        expect(controller).to receive(:sign_out).with(admin)

        get :index
      end
    end

    context "when user is signed in" do
      it "logs out the user" do
        user = create(:user,:user1)  # Replace with your user creation method
        sign_in user

        expect(controller).to receive(:admin_signed_in?).and_return(false)
        expect(controller).to receive(:user_signed_in?).and_return(true)
        expect(controller).to receive(:current_user).and_return(user)
        expect(controller).to receive(:sign_out).with(user)

        get :index
      end
    end

    context "when neither admin nor user is signed in" do
      it "does not attempt to log out" do
        expect(controller).to receive(:admin_signed_in?).and_return(false)
        expect(controller).to receive(:user_signed_in?).and_return(false)
        expect(controller).not_to receive(:sign_out)

        get :index
      end
    end
  end
end
