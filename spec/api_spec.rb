# api_spec.rb
require './app/user_api'
require 'rspec'
require 'rack/test'

def post_json(uri, json)
  post(uri, json, {format: :json, "CONTENT-TYPE" => "application/json"})
end


test_user = {:email => 'hello@world.com', :name => 'world', :password => 'hello', :password_confirmation => 'hello'}

describe UserAPI do
  include Rack::Test::Methods

  def app
    UserAPI
  end

  describe UserAPI do
    describe "GET /v1/users/" do
      it "database returns empty array of users" do
        get "/v1/users"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq []
      end
    end
    describe "POST /v1/users/signup" do
      it "requires all fields" do
        post "/v1/users/signup"
        expect(last_response.status).to eq(400)
      end
      
      it "requires proper email" do
        test_user[:email] = 'hello'
        post_json("/v1/users/signup", test_user)
        expect(last_response.status).to eq(400)
        test_user[:email] = 'hello@world.com'
      end
      
      it "requires matching passwords" do
        test_user[:password_confirmation] = 'notit'
        post_json("/v1/users/signup", test_user)
        expect(last_response.status).to eq(400)
        test_user[:password_confirmation] = 'hello'
      end

      it "allows for account creation" do
        post_json("/v1/users/signup", test_user)
        expect(last_response.status).to eq(201)
      end

      it "doesn't allow for duplicate emails" do
        post_json("/v1/users/signup", test_user)
        expect(last_response.status).to eq(400)
      end
    end
  end
end

