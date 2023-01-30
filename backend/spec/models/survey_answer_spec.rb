require 'rails_helper'

RSpec.describe SurveyAnswer, :type => :model do
  subject {described_class.new}

  it "anonimiza questionários" do
    expect(subject).not_to respond_to(:member_id) 
  end
end