require 'spec_helper'

describe "notifications/edit" do
  before(:each) do
    @notification = assign(:notification, stub_model(Notification,
      :user => nil,
      :image => "MyString",
      :content => "MyText",
      :dismissed => false
    ))
  end

  it "renders the edit notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", notification_path(@notification), "post" do
      assert_select "input#notification_user[name=?]", "notification[user]"
      assert_select "input#notification_image[name=?]", "notification[image]"
      assert_select "textarea#notification_content[name=?]", "notification[content]"
      assert_select "input#notification_dismissed[name=?]", "notification[dismissed]"
    end
  end
end
