# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
                            firstname: 'Firstname',
                            lastname: 'Lastname',
                            headline: 'Headline'
                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/Headline/)
  end
end
