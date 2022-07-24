require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  # A test to handle invalid user login
  test "login with invalid information" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_template root_path
    assert flash.empty?
  end
end
