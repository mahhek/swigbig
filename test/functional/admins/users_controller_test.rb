require 'test_helper'

class Admins::UsersControllerTest < ActionController::TestCase
  setup do
    @admins_user = admins_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admins_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admins_user" do
    assert_difference('Admins::User.count') do
      post :create, admins_user: @admins_user.attributes
    end

    assert_redirected_to admins_user_path(assigns(:admins_user))
  end

  test "should show admins_user" do
    get :show, id: @admins_user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admins_user.to_param
    assert_response :success
  end

  test "should update admins_user" do
    put :update, id: @admins_user.to_param, admins_user: @admins_user.attributes
    assert_redirected_to admins_user_path(assigns(:admins_user))
  end

  test "should destroy admins_user" do
    assert_difference('Admins::User.count', -1) do
      delete :destroy, id: @admins_user.to_param
    end

    assert_redirected_to admins_users_path
  end
end
