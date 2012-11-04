ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #
  setup do
  	self.request.host = "localhost"
  	self.request.port = '3000'

  	old_controller = @controller
  	@controller = HomeController.new
  	post :checkLogin, {:username => 'admin', :password =>'admin'}
  	@controller = old_controller

  end
end
