require 'test_helper'

class SwigsControllerTest < ActionController::TestCase
  test "should get top_ten_list" do
    get :top_ten_list
    assert_response :success
  end

end
