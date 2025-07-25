RSpec.shared_examples "skipped controller tests" do
  it "skips these tests" do
    skip("This controller is not currently used in the application")
  end
end
