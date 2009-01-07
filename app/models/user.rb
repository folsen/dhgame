require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  has_many :progresses

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  #TODO implement
  #This sets the episode and task columns to the right position
  def current_position=(task)
    self.episode = task.episode.position
    self.task = task.position
  end
  
  #This gets the episode and task columns to the right position
  def current_position
    "#{episode}.#{task}"
  end
  
  #creates a progress for the user and task
  def make_progress(task_object, answer)
    if APP_SETTINGS['send_sms'] && task_object.progresses.empty?
      api = Clickatell::API.authenticate(APP_SETTINGS['clickatell']['api'], APP_SETTINGS['clickatell']['user'], APP_SETTINGS['clickatell']['pass'])
      msg = "#{self.login} just passed #{task_object.name}"
      APP_SETTINGS['contacts'].each do |key, number|
        api.send_message(number, msg)
      end
    end
    p = Progress.create(:task => task_object, :episode => task_object.episode, :answer => answer, :user => self)
    self.save
    p.save
  end

  #returns array of all the teammates a user has
  def teammates
    teammates = User.find(:all, :conditions => ["team = ?", self.team]) unless self.team.empty? || self.team == "Single Player"
    if teammates.nil?
      return []
    else
      return teammates
    end
  end
  
  #checks if the users headstart has begun on an episode
  #TEST
  def headstart_has_begun?(episode_object)
    progress = self.progresses
    if progress.nil?
      return false
    else
      #get the latest progresses for the previous episode and check if this user is in there
      previous_ep = episode_object.higher_item
      unless previous_ep.nil?
        latest = Progress.find(:all, :conditions => {:position => 1..episode_object.headstart_count, 
          :task_id => previous_ep.tasks.last.id})
        latest.each do |p|
          if p.user == self && episode_object.start_time - episode_object.headstart.minutes < Time.now
            return true
          end
        end
      end
      return false
    end
  end
  
  #check to see if a user is allowed to access a task
  #TEST this right fucking here
  def validate_task_request?(task_object)
    #if the task object doesnt exist or the episode hasn't been released yet
    if task_object.nil? || (task_object.episode.start_time > Time.now  && !headstart_has_begun?(task_object.episode))
      return false
    end
    
    progress = self.progresses #get the users progresses into progress
    #if the user has no previous progress and it's the first task of the first episode
    if progress.empty? && task_object.position == 1 && task_object.episode.position == 1
      return true
    #otherwise if the progress isnt empty and the users previous passed task + 1 is the same as this tasks position
    #i.e. he is on the right task and his last progress episode is the same as this episode
    elsif !progress.empty? && progress.last.task.position + 1 == task_object.position && progress.last.episode.position == task_object.episode.position
      return true
    #or if the progresses isnt empty and the tasks position is 1 and the last progress episode + 1 is this episode
    #i.e. he is on the first task of a new episode
    elsif  !progress.empty? && task_object.position == 1 && progress.last.episode.position + 1 == task_object.episode.position
      return true
    else
      #if it's none of these, he is requesting the wrong task
      return false
    end
      
  end

end
