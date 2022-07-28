require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:saurabh)
    @admin = users(:saurabh)
    @non_admin = users(:rishabh)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.firstname + ' ' + user.lastname

      # Admin will not see delete link in front of his name
      if user != @admin
        assert_select 'a[href=?]', user_path(user), text: 'Delete'
      end
    end

    # Test for successful delete by admin
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    #  There will be no Delete links for non-admin
    assert_select 'a', text: "Delete", count: 0
  end
end
