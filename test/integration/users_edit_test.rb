require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup 
    # Pulls a dummy user from test dB
    @user = users(:saurabh)
  end

  test "unsuccessful edit" do
    # Just login the user before editing details
    log_in_as(@user)
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

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_template 'users/edit'
    new_fname = "Foo"
    new_email = "admin@gmail.com"
    patch user_path(@user), params: { user: {  firstname: new_fname, 
                                                email: new_email,
                                                password: "",
                                                password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user 
    @user.reload     # To see the updated changes
    assert_equal new_fname, @user.firstname
    assert_equal new_email, @user.email
  end
end
