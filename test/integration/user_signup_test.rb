require 'test_helper'
require 'net/http'
class UserSignupTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
	end
	test "invalid signup information" do 
		get signup_path	
		before_count = User.count
		#post url: '/user',
		assert_no_difference 'User.count' do
			post 'http://localhost:3000/user', 
			user: {
				name:"",
				email:"baby.voi1992@gmail.com",
				password: "12345",
				password_confirmation: "123456"
			}
		end
		after_count = User.count
		assert_equal before_count, after_count
		assert_template 'user/new'
	end

	test "valid signup information" do
		get signup_path
		assert_difference 'User.count',1 do
			post 'http://localhost:3000/user',
			user: {
				name:"Example User",
				email:"baby.voi1998@gmail.com",
				password: "123456",
				password_confirmation: "123456"
			}
		end
		assert_equal 1 ,ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		log_in_as(user)
		assert_not is_logged_in?
		get edit_account_activation_path("invalid token")
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email: 'wrong')
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email:user.email)
		assert user.reload.activated?
		follow_redirect!
		assert_template 'user/show'
		assert is_logged_in?
		 # assert_template 'user/show'
		 # assert is_logged_in?
	end
end