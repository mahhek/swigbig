require 'test_helper'

class UserRewardsControllerTest < ActionController::TestCase
  test "should get rewards" do
    get :rewards
    assert_response :success
  end

end
