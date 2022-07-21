require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(firstname: "new", lastname:"user", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "firstname should be present" do
    @user.firstname = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "lastname should be present" do
    @user.lastname = "     "
    assert_not @user.valid?
  end

  test "firstname should not be too long" do
    @user.firstname = "a" * 51
    assert_not @user.valid?
  end

  test "lastname should not be too long" do
    @user.lastname = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
end
