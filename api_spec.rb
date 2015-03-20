# api_spec.rb
require 'rack/test'
require '../app/user_api'

describe UserAPI::API do
  include Rack::Test::Methods

  def app
    UserAPI::API
  end

  describe UserAPI::API do
    describe "GET /v1/users/" do
      it "returns array of users" do
        get "/v1/users"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq []
      end
    end
  end
end

