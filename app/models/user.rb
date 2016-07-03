class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
	validates :name, presence: true,length: { maxium: 50, minimum: 5 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { minium: 255, minimum: 6} ,
					format: {with:VALID_EMAIL_REGEX},
					uniqueness: { case_sensitive: false}
	has_secure_password
	validates :password,length: {minimum: 6}, allow_blank: true
  def User.digest(string)
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
																										BCrypt::Engine.cost
			 BCrypt::Password.create(string,cost: cost)
	end

  #Returns a random token
  def User.new_token
		SecureRandom.urlsafe_base64
	end

  #Sets the password reset attributes
  def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_send_at,Time.zone.now)
	end



	#Remembers a user in the database for use in persistent session.
  def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest,User.digest(remember_token))
	end

  def forget
		update_attribute(:remember_digest,nil)
	end

#activate a account
  def activate
		self.update_attribute(:activated, true)
		self.update_attribute(:activated_at, Time.zone.now)
	end

  def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

  def authenticated?(attribute, remember_token)
		digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(remember_token)
	end

  def  password_reset_expired?
			reset_send_at < 2.hours.ago
	end
  private

  def downcase_email
		self.email = email.downcase
	end
  def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end
end