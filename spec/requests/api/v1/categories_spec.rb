require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe "Api::V1::Categories", type: :request do
  let!(:user)                  { FactoryBot.create(:user) }

  # const
  API_V1 = '/api/v1'

  describe "#GET" do
    describe "#index" do
      before do 
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        FactoryBot.create_list(:category, 5)
        get "#{API_V1}/categories", headers: auth_headers
      end

      it 'returns categories' do
        expect(json['categories'].size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end
     
    end

    describe "#show" do
      context 'with valid parameters' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          get "#{API_V1}/categories/#{my_category.id}", params: { id: my_category.id }, headers: auth_headers
        end

        it 'returns the name' do
          expect(json['category']['name']).to eq(my_category.name)
        end

        it 'returns a created status' do
          expect(response.status).to eq(200)
        end
      end

      context 'with invalid parameters' do
        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          get "#{API_V1}/categories/#{20}", params: { id: 20 }, headers: auth_headers
        end

        it 'returns status code 404' do
          expect(response.status).to eq(404)
        end
      end
    end
  end

  describe "#POST" do
    describe "#create" do
      context 'with valid parameters' do
        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          post "#{API_V1}/categories", params:
                            { category: {
                              name: 'Cat 1'
                            } }, headers: auth_headers
        end

        it 'returns the name' do
          expect(json['category']['name']).to eq('Cat 1')
        end

        it 'returns a created status' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          post "#{API_V1}/categories", params:
                            { category: { 
                              name: Faker::Lorem.characters(number: 200)
                            } }, headers: auth_headers
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invalid parameters' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          post "#{API_V1}/categories", params:
                            { category: { 
                              name: ''
                            } }, headers: auth_headers
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'duplicated category name' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          post "#{API_V1}/categories", params:
                            { category: { 
                              name: my_category.name
                            } }, headers: auth_headers
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe "#PATCH" do
    describe "update" do
      context 'with valid parameters' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          patch "#{API_V1}/categories/#{my_category.id}", params:
                            { category: {
                              id: my_category.id,
                              name: 'New Category'
                            } }, headers: auth_headers
        end

        it 'returns the name' do
          expect(json['category']['name']).to eq('New Category')
        end

        it 'returns a created status' do
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#DELETE" do
    describe "destroy" do
      let!(:category) { FactoryBot.create(:category) }

      before do
        headers = { 'Accept' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        delete "#{API_V1}/categories/#{category.id}", params: { id: category.id }, headers: auth_headers
      end

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'returns 0 category' do
        expect(Category.count).to eq(0)
      end
    end
  end
end
