require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags(:one)

    # @tag.id = 3
    @tag.name = 'tag3'
    @tag.description = 'desc3'
    @tag.user_id = 1
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag" do
    assert_difference('Tag.count') do
      post :create, tag: { description: @tag.description, name: @tag.name, user_id: @tag.user_id }
    end

    assert_redirected_to tags_path
  end

  test "should show tag" do
    get :show, id: @tag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tag
    assert_response :success
  end

  test "should update tag" do
    put :update, id: @tag, tag: { description: @tag.description, name: @tag.name }
    assert_redirected_to tag_path(assigns(:tag))
  end

  # test "should destroy tag" do
  #   assert_difference('Tag.count', -1) do
  #     delete :destroy, id: @tag
  #   end

  #   assert_redirected_to tags_path
  # end
end
