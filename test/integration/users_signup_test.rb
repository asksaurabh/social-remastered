require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { firstname: "", 
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { id: "1",
                                        firstname: "saurabh",
                                        lastname: "Kumar",
                                        email: "user@invalid.com",
                                        password: "foobar",
                                        password_confirmation: "foobar" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?                  # To check if the user is logged in after immediate signup
    assert_not flash.empty?
  end
end
