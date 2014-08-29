require 'spec_helper'

describe "charges/index" do
  before(:each) do
    assign(:charges, [
      stub_model(Charge,
        :user_id => "User",
        :sale_id => "Sale",
        :plan_id => 1
      ),
      stub_model(Charge,
        :user_id => "User",
        :sale_id => "Sale",
        :plan_id => 1
      )
    ])
  end

  it "renders a list of charges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Sale".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
