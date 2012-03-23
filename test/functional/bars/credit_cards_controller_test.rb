require 'test_helper'

class Bars::CreditCardsControllerTest < ActionController::TestCase
  setup do
    @bars_credit_card = bars_credit_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bars_credit_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bars_credit_card" do
    assert_difference('Bars::CreditCard.count') do
      post :create, bars_credit_card: @bars_credit_card.attributes
    end

    assert_redirected_to bars_credit_card_path(assigns(:bars_credit_card))
  end

  test "should show bars_credit_card" do
    get :show, id: @bars_credit_card.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bars_credit_card.to_param
    assert_response :success
  end

  test "should update bars_credit_card" do
    put :update, id: @bars_credit_card.to_param, bars_credit_card: @bars_credit_card.attributes
    assert_redirected_to bars_credit_card_path(assigns(:bars_credit_card))
  end

  test "should destroy bars_credit_card" do
    assert_difference('Bars::CreditCard.count', -1) do
      delete :destroy, id: @bars_credit_card.to_param
    end

    assert_redirected_to bars_credit_cards_path
  end
end
