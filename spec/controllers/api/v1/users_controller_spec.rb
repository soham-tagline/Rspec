# frozen_string_literal: true

require 'rails_helper'
require 'api_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:call) { get api_v1_users_path }

  let(:user) { create(:user) }

  describe 'GET /index' do
    let(:users) { create_list(:user, 5) }
    # Here, I have created the list of users, to check if the response is correct ot not.

    before { users }
    # Here, I have created the before block, to create the users before the request.

    it 'renders a successful response' do
      call

      body = JSON.parse(response.body)
      expect(body['data'].count).to be(5)
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:call) { get api_v1_user_path(user) }

    let(:expected_response_body) do
      {
        'data' => {
          'id' => user.id.to_s,
          'type' => 'user',
          'attributes' => {
            'firstname' => user.firstname,
            'lastname' => user.lastname,
            'headline' => user.headline,
            'dob' => user.dob.strftime('%Y-%m-%d'),
            'email' => user.email
          }
        }
      }
    end

    before { user }

    it 'renders a successful response' do
      call
      expect(JSON(response.body)).to eq(expected_response_body)
    end
  end

  describe 'POST /create' do
    let(:attributes) do
      {
        "firstname": 'soham',
        "lastname": 'tejani',
        "email": 'soham.tagline4@gmail.com',
        "password": 123_456,
        "headline": 'headline',
        "dob": '2022-05-12'
      }
    end

    let(:expected_attributes) { attributes.except(:password).as_json }

    let(:request) { post api_v1_users_path, params: { user: attributes } }

    context 'with valid parameters' do
      it 'creates a new User' do
        expect { request }.to change(User, :count).by(1)
        # Here, I have made one helper method in Rspec, that is in api_helper.rb, which is required in the spec file.
        expect(json_body.dig('data', 'attributes')).to eq(expected_attributes)
      end
    end

    context 'with invalid parameters' do
      let(:attributes) do
        {
          "firstname": 'soham',
          "lastname": 'tejani',
          "email": 'IamWrongEmail',
          "password": 123_456,
          "headline": 'headline',
          "dob": '2022-05-12'
        }
      end

      let(:expected_errors) do
      end

      it 'does not create a new User' do
        expect { request }.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested user' do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: new_attributes }
        user.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the user' do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete user_url(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      delete user_url(user)
      expect(response).to redirect_to(users_url)
    end
  end
end
