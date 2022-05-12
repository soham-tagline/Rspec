require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        firstname: "Firstname",
        lastname: "Lastname",
        headline: "Headline"
      ),
      User.create!(
        firstname: "Firstname",
        lastname: "Lastname",
        headline: "Headline"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", text: "Firstname".to_s, count: 2
    assert_select "tr>td", text: "Lastname".to_s, count: 2
    assert_select "tr>td", text: "Headline".to_s, count: 2
  end
end
