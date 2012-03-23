require 'test_helper'

class BarControllerTest < ActionController::TestCase
  test "should get favourite_bar" do
    get :favourite_bar
    assert_response :success
  end

end
