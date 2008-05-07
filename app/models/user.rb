require 'digest/sha1'

class User < ActiveRecord::Base
  
  validates_presence_of :name 
  validates_uniqueness_of :name 

  attr_accessor :password_confirmation 
  
  cattr_accessor :active_user

  validates_confirmation_of :password 
  
  has_many :progresses
  
  def before_validation_on_create
    if self.first_name.nil?
      self.first_name = "Anonymous"
    end
    if self.last_name.nil?
      self.last_name = "Coward"
    end
    if self.email.nil? || self.email.empty?
      self.email = "click@to-edit.com"
    end
    if self.phone.nil? || self.phone.empty?
      self.phone = "070-EDIT-ME"
    end
    if self.row.nil? || self.row.empty?
      self.row = "?"
    end
    if self.seat.nil? || self.seat.empty?
      self.seat = "?"
    end
    
  end
  
  def save_episode_progress
    true
  end
  
  def save_task_progress
    true
  end
  
  def make_progress(task_object, answer)
    p = Progress.create(:task => task_object, :episode => task_object.episode, :answer => answer, :user => self)
    self.save
    p.save
  end
  
  def validate 
    errors.add_to_base("Missing password") if hashed_password.blank?  
  end
  
  def password 
    @password 
  end
   
  def password=(pwd) 
    @password = pwd 
    create_new_salt 
    self.hashed_password = User.encrypted_password(self.password, self.salt) 
  end 
  
  def self.authenticate(name, password) 
    user = self.find_by_name(name) 
    if user 
      expected_password = encrypted_password(password, user.salt) 
      if user.hashed_password != expected_password 
        user = nil 
      end
    end
    user 
  end
  
  def is_admin?
    if self.admin == 1
      logger.info("ninja")
      true
    else      
      logger.info("samuraj")
      false
    end
  end
  
  def self.check_if_admin(user)
   if user.admin == 1
     true
   else
     false
   end
  end
  
   
  private 
    
  def self.encrypted_password(password, salt) 
    string_to_hash = password + "dhgame4thewin" + salt # 'wibble' makes it harder to guess 
    Digest::SHA1.hexdigest(string_to_hash) 
  end 
    
  def create_new_salt 
    self.salt = self.object_id.to_s + rand.to_s 
  end 


  
end
