require 'spec_helper'

describe "charges/edit" do
  before(:each) do
    @charge = assign(:charge, stub_model(Charge,
      :user_id => "MyString",
      :sale_id => "MyString",
      :plan_id => 1
    ))
  end

  it "renders the edit charge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", charge_path(@charge), "post" do
      assert_select "input#charge_user_id[name=?]", "charge[user_id]"
      assert_select "input#charge_sale_id[name=?]", "charge[sale_id]"
      assert_select "input#charge_plan_id[name=?]", "charge[plan_id]"
    end
  end
end
