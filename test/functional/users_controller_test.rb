require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)

    @user.name = 'user3'
    @user.username = 'user3'
    @user.password = 'desc3'
    @user.type_id = 1
  end

  test "title should contain controller name" do
    get :index
    assert_select "title", "Detox : #{@controller.controller_name.capitalize}", "Title should contain controller name: #{@controller.controller_name.capitalize}"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { name: @user.name, password: @user.password, type_id: @user.type_id, username: @user.username }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { name: @user.name, password: @user.password, type_id: @user.type_id, username: @user.username }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
