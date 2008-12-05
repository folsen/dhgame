require 'digest/sha1'

class User < ActiveRecord::Base
  
  validates_presence_of :name 
  validates_uniqueness_of :name 

  attr_accessor :password_confirmation 
  
  #TODO replace with restful_auth and find all references to active_user and replace aswell
  cattr_accessor :active_user

  validates_confirmation_of :password 
  
  has_many :progresses
  
  #checks if the user has headstart
  #TODO refactor, user_object not needed in model
  #TEST THIS
  def self.has_headstart(episode_object, user_object)
    progress = user_object.progresses
    if progress.nil?
      return false
    else
      #get the latest progresses for the previous episode and check if this user is in there
      previous_ep = episode_object.higher_item
      unless previous_ep.nil?
        latest = Progress.find(:all, :conditions => {:position => 1..episode_object.headstart_count, 
          :task_id => previous_ep.tasks.last.id})
        latest.each do |p|
          #TODO move out the time comparing from here, this method should just check if the user has a headstart or not
          if p.user == user_object && episode_object.start_time - episode_object.headstart.minutes < Time.now
            return true
          end
        end
      end
      return false
    end
  end
  
  #set standard names, emails and such
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
      self.row = "row"
    end
    if self.seat.nil? || self.seat.empty?
      self.seat = "seat"
    end
    
  end
  
  #TODO implement to update database with current episode
  def save_episode_progress
    true
  end
  
  #TODO implement to update database with current task
  def save_task_progress
    true
  end
  
  #creates a progress for the user and task
  def make_progress(task_object, answer)
    p = Progress.create(:task => task_object, :episode => task_object.episode, :answer => answer, :user => self)
    self.save
    p.save
  end
  
  #TODO remove?
  def validate 
    errors.add_to_base("Missing password") if hashed_password.blank?  
  end
  
  #TODO remove?
  def password 
    @password 
  end
   
  #TODO replace with restful_auth function
  def password=(pwd) 
    @password = pwd 
    create_new_salt 
    self.hashed_password = User.encrypted_password(self.password, self.salt) 
  end 
  
  #TODO replace with restful_auth function
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
  
  #Check to see if the user is admin
  #this is also replaced with restful_auth
  def is_admin?
    if self.admin == 1
      #logger.info("ninja")
      true
    else      
      #logger.info("samuraj")
      false
    end
  end
  
  #check to see if another (I.E not this) user is admin
  #this is also replaced with restful_auth
  #it is currently used in login
  def self.check_if_admin(user)
   if user.admin == 1
     true
   else
     false
   end
  end
  
   
  private 
    
  #replace
  def self.encrypted_password(password, salt) 
    string_to_hash = password + "dhgame4thewin" + salt # 'wibble' makes it harder to guess 
    Digest::SHA1.hexdigest(string_to_hash) 
  end 
  #replace
  def create_new_salt 
    self.salt = self.object_id.to_s + rand.to_s 
  end 


  
end
