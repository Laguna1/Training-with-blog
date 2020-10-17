class User < ActiveRecord::Base
    has_many :articles
    validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
    validates :email, presence: true, length: { maximum: 105 }, uniqueness: { case_sensitive: false }, 
    format: { with: VALID_EMAIL_REGEX }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    before_save { self.email = email.downcase }
end
