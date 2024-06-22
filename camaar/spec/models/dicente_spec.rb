require "rails_helper"

describe Dicente do
  subject{FactoryGirl.create(:dicente,
                              user: FactoryGirl.create(:user, :dicente))}

  context "Validations" do
    it "should valid"


  end
end
