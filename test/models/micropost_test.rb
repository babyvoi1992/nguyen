require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = user(:michael)
    @micropost = Micropost.new(user_id: @user.id)
  end

  test "should be valid" do
      assert @user.valid?
  end
end
