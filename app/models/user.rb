class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = self.email.downcase }
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

  # Returns true if the given remember token matches the digest
  # Similar to authenticate method.
  def authenticated?(browser_remember_token)

    # Two separate browser logout may cause digest be nil.
    if remember_digest.nil?
      return false
    else
      BCrypt::Password.new(remember_digest).is_password?(browser_remember_token)
    end
  end
end
