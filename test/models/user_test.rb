require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(firstname: "new", lastname:"user", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
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

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lowercase" do
    mixed_email = "Bar@EXAMple.com"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test "password should be present(non blank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end  

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # Test for authenticated method
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  # If user destroyed, then all microposts related to it destroyed
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    saurabh = users(:saurabh)
    rishabh = users(:rishabh)
    assert_not saurabh.following?(rishabh)
    saurabh.follow(rishabh)
    assert saurabh.following?(rishabh)
    assert rishabh.followers.include?(saurabh)
    saurabh.unfollow(rishabh)
    assert_not saurabh.following?(rishabh)

    # Users can't follow themselves
    saurabh.follow(saurabh)
    assert_not saurabh.following?(saurabh)
  end

  test "feed should have the right posts" do
    saurabh = users(:saurabh)
    archer  = users(:archer)
    lana    = users(:lana)
    # See relationships.yml
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert saurabh.feed.include?(post_following)
    end
    # Self-posts for user with followers
    saurabh.microposts.each do |post_self|
      assert saurabh.feed.include?(post_self)
    end
    # Posts from non-followed user
    archer.microposts.each do |post_unfollowed|
      assert_not saurabh.feed.include?(post_unfollowed)
    end
  end
end
