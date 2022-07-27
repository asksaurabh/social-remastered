require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup 
    # Pulls a dummy user from test dB
    @user = users(:saurabh)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    patch user_path(@user), params: { user: {  firstname: "", 
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'

    # test for correct number of error messages
    assert_select "div.alert", text: "The form contains 4 errors."
  end
end
