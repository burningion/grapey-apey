# config.ru
require './app/user_api'

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run Rack::Cascade.new [UserAPI, Web]
