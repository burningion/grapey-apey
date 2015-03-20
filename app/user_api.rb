require 'sinatra'
require 'grape'
require 'sinatra/activerecord'
require 'bcrypt'
require 'grape-swagger'

set :database, {adapter: "sqlite3", database: "users.sqlite3"}

class User < ActiveRecord::Base
  before_create :securify
  
  validates :password, confirmation: true
  validates :email, uniqueness: true

  def as_json(options)
    {:id => id, :name => name, :email => email, :authentication_token => authentication_token }
  end
  
  private 
  def securify
    self.password = BCrypt::Password.create(self.password)
    self.authentication_token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end

class SameAs < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless params[attr_name] == params[@option]
      raise Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "and password_confirmation must match"
    end
  end
end

class UniqueEmail < Grape::Validations::Base
  def validate_param!(attr_name, params)
    if User.exists? :email => params[attr_name]
      raise Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "address already taken"
    end
  end
end

class UserAPI < Grape::API
  format :json
  version 'v1', using: :path
  
  desc 'API Root'
  get do
    { 'user_signup': '/v1/users/signup' }
  end
  
  namespace :users do

    desc 'Create a user account'
    params do
      requires :email, allow_blank: false, regexp: /.+@.+/, unique_email: true, documentation: { example: 'you@email.com' }
      requires :name, type: String, allow_blank: false, documentation: { example: 'Test User' }
      requires :password, type: String, allow_blank: false, same_as: :password_confirmation 
      requires :password_confirmation, type: String, allow_blank: false
    end

    post :signup do
      @user = User.new(name: params[:name], email: params[:email], password: params[:password])
      @user.save!
      return @user
    end

    desc 'List all user accounts'
    get do
      User.all
    end
  end
  
  add_swagger_documentation :api_version => self.version, :mount_path => '/swagger_doc.json'
end

class Web < Sinatra::Base
  set :public_folder, 'public'
  
  get '/' do
    redirect '/index.html'
  end

  get '/swagger' do
    redirect '/swagger/index.html'
  end

  get '/v1/swagger_doc.json/users.json' do
    # hackey hack for bug in grape-swagger and no implementation of swagger 2.0 spec yet :(
    redirect '/v1/swagger_doc.json/users'
  end
end

use Rack::Session::Cookie

