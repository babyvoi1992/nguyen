require 'test_helper'

class UserEditTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "invalid edit" do
    log_in_as(@user)
    get edit_user_path @user
    patch user_path(@user), user: {
        name: "",
        email: "user@invalid",
        password: "",
        password_confirmation:"1234"
    }

    assert_template 'user/edit'
  end

  test "valid edit" do
    log_in_as (@user)
    name ="tran anh nguyen"
    email = "baby.voi1992@gmail.com"
    get edit_user_path(@user)
    patch user_path @user, user:{
        name: name,
        email: email,
        password: "",
        password_confirmation: ""

    }
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    @user.reload
    name = @user.name
    assert_equal name, "tran anh nguyen"
    assert_equal @user.email , 'baby.voi1992@gmail.com'
  end
end
