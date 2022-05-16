# frozen_string_literal: true

require 'rails_helper'
require 'api_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:call) { get api_v1_users_path }

  let(:user) { create(:user) }

  describe 'GET /index' do
    let(:users) { create_list(:user, 5) }
    before { users }
    it 'returns a all 5 users in a response' do
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

    it 'returns a details of requested user' do
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

      let(:expected_errors) { ['Email is invalid'] }

      it 'does not create a new User' do
        expect { request }.to change(User, :count).by(0)
        expect(json_body['errors']).to eq(expected_errors)
      end
    end
  end

  describe 'PATCH /update' do
    let(:request) { post api_v1_users_path, params: { user: attributes } }
    context 'with valid parameters' do
      let(:user) { create(:user) }
      let(:attributes) do
        {
          "firstname": 'soham',
          "lastname": 'tejani',
          "email": 'random@gmail.com',
          "password": 123_456,
          "headline": 'headline',
          "dob": '2022-05-12'
        }
      end
      let(:expected_attributes) { attributes.except(:password).as_json }

      it 'updates the requested user' do
        request
        expect(json_body['data']['attributes']).to eq(expected_attributes)
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

      it "wan't updates the requested user and return error messages" do
        request
        expect(json_body['errors']).to eq(['Email is invalid'])
      end
    end

    context 'with already used email' do
      let(:attributes) do
        {
          "firstname": 'soham',
          "lastname": 'tejani',
          "email": user.email,
          "password": 123_456,
          "headline": 'headline',
          "dob": '2022-05-12'
        }
      end

      it "wan't updates the requested user and return error messages" do
        request
        expect(json_body['errors']).to eq(['Email has already been taken'])
      end
    end
  end

  describe 'DELETE /destroy' do
    before { user }
    let(:request) { delete api_v1_user_path(user) }

    it 'destroys the requested user' do
      expect { request }.to change(User, :count).by(-1)
    end
  end
end
