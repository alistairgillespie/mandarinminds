require 'spec_helper'

describe "lessons/new" do
  before(:each) do
    assign(:lesson, stub_model(Lesson,
      :student => nil,
      :teacher => nil
    ).as_new_record)
  end

  it "renders new lesson form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", lessons_path, "post" do
      assert_select "input#lesson_student[name=?]", "lesson[student]"
      assert_select "input#lesson_teacher[name=?]", "lesson[teacher]"
    end
  end
end
