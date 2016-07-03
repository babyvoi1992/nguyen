require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  		@user = User.new(name: "Example User",email:"User@Example.com")
  end

  

  test "name should be " do
  	@user.name = "            "
  	assert_not @user.valid?
  end

  test "email should be " do
  	@user.email="      "
  	assert_not @user.valid?
	end
  
  test "name should not be too long " do
  	@user.email = "a"*51
  	assert @user.valid?
  end

  test "email should not be too long " do
  	@user.email = "a"*256
  	assert @user.valid?
  	end

  test "email validation should accept valid address" do	
  	valid_addresses = %w[user@exmaple.com 
  						 USER@foo.com 
  						 A_US-ER@foo.bar.org 
  						 first.last@foo.jp 
  						 alice+bob@baz.cn]
  	valid_addresses.each do |valid_address|
  	@user.email = valid_address		
  	assert @user.valid?, "Address #{valid_address.inspect} should be valid"
  	end			 
  end
  test "email validation should reject invalid addresses" do 
  	invalid_addresses = %w[
  						user@exmaple,com
  						user _at_foo.org
  						user.name@exmaple.
  						foo@bar_baz.com
  						foo@bar+baz.com]
  	invalid_addresses.each do |invalid_address|
  	@user.email = invalid_address
  	assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
  	end				
  end

	test "authentication return nil for user with nul digest" do
		assert_not @user.authenticated?(:remember,'')
	end

end
