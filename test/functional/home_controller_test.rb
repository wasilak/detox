require 'test_helper'

class HomeControllerTest < ActionController::TestCase

	test "should get index" do
	get :index
	assert_response :success
	end

	test "should get welcome message" do
		get :index

	assert_select 'p', 'Home page.'
	end

	test "title should contain controller name" do
		get :index
		assert_select "title", "Detox : #{@controller.controller_name.capitalize}", "Title should contain controller name: #{@controller.controller_name.capitalize}"
	end

end
