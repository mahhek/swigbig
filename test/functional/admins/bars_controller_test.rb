require 'test_helper'

class Admins::BarsControllerTest < ActionController::TestCase
  setup do
    @admins_bar = admins_bars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admins_bars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admins_bar" do
    assert_difference('Admins::Bar.count') do
      post :create, admins_bar: @admins_bar.attributes
    end

    assert_redirected_to admins_bar_path(assigns(:admins_bar))
  end

  test "should show admins_bar" do
    get :show, id: @admins_bar.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admins_bar.to_param
    assert_response :success
  end

  test "should update admins_bar" do
    put :update, id: @admins_bar.to_param, admins_bar: @admins_bar.attributes
    assert_redirected_to admins_bar_path(assigns(:admins_bar))
  end

  test "should destroy admins_bar" do
    assert_difference('Admins::Bar.count', -1) do
      delete :destroy, id: @admins_bar.to_param
    end

    assert_redirected_to admins_bars_path
  end
end
