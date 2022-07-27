require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup 
    @user = users(:saurabh)
    @other_user = users(:rishabh)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { firstname: @user.firstname, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # Can't issue GET req users/1/edit if u r logged in as users/2
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # Can't issue PATCH req users/1/edit if u r logged in as users/2
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { firstname: @user.firstname, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
