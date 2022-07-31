class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # returns the hash digest of a given string
  def User.digest(password)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(password, cost: cost)
  end

  # Remembering users involves creating a remember token and saving the digest of the token to the database.

  # returns a random length-22 token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
    return remember_digest
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end

  # Forgets a user(Inverse of remember)
  def forget 
    self.update_attribute(:remember_digest, nil)
  end

  # Generalized method to return true if token matches corres digest
  # Similar to authenticate method.
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    # Two separate browser logout may cause digest be nil.
    if digest.nil?
      return false
    else
      BCrypt::Password.new(digest).is_password?(token)
    end
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), 
                   reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    # Password reset sent earlier than two hours ago.
    reset_sent_at < 2.hours.ago
  end

  private
    # Converts email to all lowercase.
    def downcase_email
      self.email = email.downcase
    end
    
    def create_activation_digest
      # Create the token and digest.
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
