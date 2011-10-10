# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password, :accessible
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :wish_items, :dependent => :destroy
  has_one :drawn_name, :foreign_key => "giver_id", :dependent => :destroy
  has_many :draw_exclusions, :foreign_key => "excluder_id", :dependent => :destroy
  has_many :draw_excluding, :through => :draw_exclusions, :source => :excluded
  has_many :ownerships, :foreign_key => "owner_id", :dependent => :destroy
  has_many :owned, :through => :ownerships, :source => :owned

  default_scope :order => 'users.name ASC'
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
                   :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 12..40 }

  before_validation :update_password
  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def is_admin=(v)
    self.admin = v
  end
  
  def is_admin
    self.admin
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  # does the user exclude a specified user from being drawn?
  def draw_excluding?(excluded)
    draw_exclusions.find_by_excluded_id(excluded)
  end

  # exclude a specified user from being drawn
  def draw_exclude!(excluded)
    draw_exclusions.create!(:excluded_id => excluded.id)
  end
  
  # include a specified user so that the name can be drawn
  def draw_include!(excluded)
    draw_exclusions.find_by_excluded_id(excluded).destroy
  end
  
  # does the user own the specified user
  def owns?(owned)
    ownerships.find_by_owned_id(owned)
  end

  def own!(owned)
    ownerships.create!(:owned_id => owned.id)
  end

  def unown!(owned)
    ownerships.find_by_owned_id(owned).destroy
  end
  
  # get all users that can be excluded (i.e., all users in the draw other than the 
  # current user and already excluded users)
  def self.draw_excludable(user)
    clause = "in_draw = 't' and id <> ?"
    if user.draw_exclusions.count > 0
      clause += " and id not in (#{user.draw_exclusions.map(&:excluded_id).join(",")})"
    end
    where(clause, user)
  end

  # get all users that can be owned (i.e., all users other than the 
  # current user and already owned users)
  def self.ownable(user)
    clause = "admin = 'f' and id <> ?"
    if user.ownerships.count > 0
      clause += " and id not in (#{user.ownerships.map(&:owned_id).join(",")})"
    end
    where(clause, user)
  end

  private
  
    def encrypt_password
      if encrypted_password.blank? || password != encrypted_password[0..39]
        self.salt = make_salt if new_record?
        self.encrypted_password = encrypt(password)
      end
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
    def mass_assignment_authorizer
      super + (accessible || [])
    end
    
    def update_password
      if password.blank? && !encrypted_password.blank?
        self.password = encrypted_password[0..39]
        if password_confirmation.blank?
          self.password_confirmation = password
        end
      end
    end
end
