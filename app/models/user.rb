# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#
# Indexes
#
#  index_users_on_name   (name) UNIQUE
#  index_users_on_email  (email) UNIQUE
#

class User < ActiveRecord::Base
  attr_accessor   :password

  # Define which attributes are accessible to the user
  attr_accessible :name, :email, :password, :password_confirmation

  # Ventposts
  has_many :ventposts, :dependent => :destroy

  # Relationships
  has_many :relationships, :dependent => :destroy,
                           :foreign_key => 'follower_id'
  has_many :reverse_relationships, :dependent =>:destroy,
                           :foreign_key => 'followed_id',
                           :class_name => 'Relationship'
  has_many :following, :through => :relationships, :source => :followed
  has_many :followers, :through => :reverse_relationships, :source => :follower

  # Votevents
  has_many :votevents, :dependent => :destroy

  # Regexes, as if the variables were not descriptive enough
  name_regex = /\A\A[\w]*[a-zA-Z\d]\Z/i
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\Z/i

  # Validations
  validates :name,  :presence   =>  true, 
                    :length     =>  { :within => 1..50 },
                    :format     =>  { :with => name_regex },
                    :uniqueness =>  { :case_sensitive => false }

  validates :email, :presence   =>  true,
                    :format     =>  { :with => email_regex },
                    :uniqueness =>  { :case_sensitive => false }

  validates :password,  :presence     =>  true,
                        :confirmation =>  true,
                        :length => { :within => 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def feed
    Ventpost.from_users_followed_by(self)
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def vote!(vent)
    votevents.create!(:ventpost_id => vent.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  class << self
    def authenticate(email, submitted_password)
      user = find_by_email(email.downcase)
      (user && user.has_password?(submitted_password)) ? user : nil
    end

    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end

  private

    def encrypt_password
      if password.present?
        self.salt = make_salt if new_record?
        self.encrypted_password = encrypt(password)
      end
    end

    def make_salt
      secure_hash("#{Time.now.utc}---#{password}")
    end

    def encrypt(string)
      secure_hash("#{salt}---#{string}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
