# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    firstname { 'MyString' }
    lastname { 'MyString' }
    headline { 'MyString' }
    dob { '2022-05-12' }
    email { Faker::Internet.email }
    # Add Faker gem for generating random data, find some more random data generators here: https://github.com/faker-ruby/faker
    password { 123_456 }
  end
end
