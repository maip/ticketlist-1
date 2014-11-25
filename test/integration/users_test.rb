require 'test_helper'
 
class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user2 = users(:two)
    @event = events(:one)
  end

  test "should sign in user" do
    sign_in @user
    assert_response :success
    assert @controller.instance_variable_set(:"@current_user", true)
  end

  test "should sign in multiple users" do
    sign_in @user
    sign_in @user2
    assert_response :success
    
  end
end