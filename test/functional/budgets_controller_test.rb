require 'test_helper'

class BudgetsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end

  test "title should contain controller name" do
  	get :index
  	assert_select "title",
        "Detox : #{@controller.controller_name.capitalize}",
        "Title should contain controller name: #{@controller.controller_name.capitalize}"
  end

  test "new budget form" do
    get :new
    assert_select "title",
        "Detox : #{@controller.controller_name.capitalize} : new",
        "Title should contain 'new'"
  end
end