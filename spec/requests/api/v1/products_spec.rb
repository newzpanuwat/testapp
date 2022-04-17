require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe "Api::V1::Products", type: :request do
  let!(:user)                  { FactoryBot.create(:user) }
  let!(:my_category)           { FactoryBot.create(:category) }
  let!(:my_category2)          { FactoryBot.create(:category) }
  let!(:prd1)                  { FactoryBot.build(:product) }
  let!(:prd2)                  { FactoryBot.build(:product) }

  # const
  API_V1 = '/api/v1/'

  describe "#GET" do
    describe "#index" do
      context 'category 1 product 1' do
        before do
          #setup
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          prd1.category_id = my_category.id
          prd1.save!
          
          # call
          get "#{API_V1}/categories/#{my_category.id}/products", headers: auth_headers
        end

        it 'returns products' do
          expect(json['products'].size).to eq(1)
          expect(json['products'][0]['category_id']).to eq(1)
        end

        it 'returns status code 200' do
          expect(response.status).to eq(200)
        end
      end

      context 'category 2 product 2' do
        before do
          #setup
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

          prd2.category_id = my_category2.id
          prd2.save!
          
          # call
          get "#{API_V1}/categories/#{my_category2.id}/products", headers: auth_headers
        end

        it 'returns products' do
          expect(json['products'].size).to eq(1)
          expect(json['products'][0]['category_id']).to eq(2)
        end

        it 'returns status code 200' do
          expect(response.status).to eq(200)
        end
      end
     
    end

    describe "#show" do
      context 'with valid parameters' do
        before do
          # setup
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          prd1.category_id = my_category.id
          prd1.save!

          # call
          get "#{API_V1}/categories/#{my_category.id}/products/#{prd1.id}", params: { id: prd1.id }, headers: auth_headers
        end

        it 'returns the name' do
          expect(json['product']['name']).to eq(prd1.name)
        end

        it 'returns a created status' do
          expect(response.status).to eq(200)
        end
      end
    end

    describe "#all" do
      context 'return all products correctly' do
        before do
          #setup
          headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          prd1.category_id = my_category.id
          prd1.save!

          prd2.category_id = my_category.id
          prd2.save!
          
          # call
          get "#{API_V1}/products", headers: auth_headers
        end

        it 'returns products' do
          expect(json['products'].size).to eq(2)
        end

        it 'returns status code 200' do
          expect(response.status).to eq(200)
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
          post "#{API_V1}/categories/#{my_category.id}/products/", params:
                            { product: {
                              name: 'Gaming Mouse',
                              qty: 3,
                              category_id: my_category.id
                            } }, headers: auth_headers
        end

        it 'returns the name' do
          expect(json['product']['name']).to eq('Gaming Mouse')
        end

        it 'returns the qty' do
          expect(json['product']['qty']).to eq(3)
        end

        it 'returns a created status' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          post "#{API_V1}/categories/#{my_category.id}/products/", params:
                            { product: { 
                               name: Faker::Lorem.characters(number: 300),
                               qty: 1,
                               category_id: my_category.id
                            } }, headers: auth_headers
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invalid parameters' do
        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          post "#{API_V1}/categories/#{99}/products/", params:
                            { product: { 
                               name: 'Test',
                               qty: 1,
                               category_id: 99
                            } }, headers: auth_headers
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'duplicate product in same category' do
        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          prd1.name = 'Test prd'
          prd1.category_id = my_category.id
          prd1.save

          post "#{API_V1}/categories/#{my_category.id}/products/", params:
                            { product: { 
                               name: prd1.name,
                               qty: 1,
                               category_id: my_category.id
                            } }, headers: auth_headers
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'invalid parameters qty' do
        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          prd1.name = 'Test prd'
          prd1.category_id = my_category.id
          prd1.save

          post "#{API_V1}/categories/#{my_category.id}/products/", params:
                            { product: { 
                               name: prd1.name,
                               qty: '',
                               category_id: my_category.id
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
        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          prd1.category_id = my_category.id
          prd1.save
          patch "#{API_V1}/categories/#{my_category.id}/products/#{prd1.id}", params:
                            { product: {
                              id: prd1.id,
                              name: 'PC',
                              qty: 2,
                              category_id: my_category.id
                            } }, headers: auth_headers
        end

        it 'returns the name' do
          expect(json['product']['name']).to eq('PC')
        end

        it 'returns the qty' do
          expect(json['product']['qty']).to eq(2)
        end

        it 'returns a created status' do
          expect(response.status).to eq(200)
        end
      end

      context 'with invalid parameters' do
        before do
          headers = { 'Accept' => 'application/json' }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          prd1.category_id = my_category.id
          prd1.save
          patch "#{API_V1}/categories/#{my_category.id}/products/#{prd1.id}", params:
                            { product: {
                               id: prd1.id,
                               name: '',
                               qty: 1,
                               category_id: my_category.id
                            } }, headers: auth_headers
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe "#DELETE" do
    describe "destroy" do
      before do
        headers = { 'Accept' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        prd1.category_id = my_category.id
        prd1.save!
        delete "#{API_V1}/categories/#{my_category.id}/products/#{prd1.id}", params: { id: prd1.id }, headers: auth_headers
      end

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'returns 0 product' do
        expect(Product.count).to eq(0)
      end
    end
  end
end
