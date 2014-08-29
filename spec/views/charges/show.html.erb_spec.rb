require 'spec_helper'

describe "charges/show" do
  before(:each) do
    @charge = assign(:charge, stub_model(Charge,
      :user_id => "User",
      :sale_id => "Sale",
      :plan_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User/)
    rendered.should match(/Sale/)
    rendered.should match(/1/)
  end
end
