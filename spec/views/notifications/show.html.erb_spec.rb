require 'spec_helper'

describe "notifications/show" do
  before(:each) do
    @notification = assign(:notification, stub_model(Notification,
      :user => nil,
      :image => "Image",
      :content => "MyText",
      :dismissed => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Image/)
    rendered.should match(/MyText/)
    rendered.should match(/false/)
  end
end
