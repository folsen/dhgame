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
  has_many :wrong_answers
  
  belongs_to :task
  
  cattr_reader :per_page
  @@per_page = 50
  
  #get the task that the user is currently on
  def task
    if self.progresses.empty?
      return Task.first_task
    end
    t = self.progresses.last.task
    if t.last?
      #if there are no more tasks, it returns nil
      task = t.episode.lower_item.tasks.first unless t.episode.lower_item.nil? 
    else
      task = t.lower_item
    end
    return task
  end

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

  #creates a progress for the user and task
  def make_progress(answer)
    if APP_SETTINGS['send_sms'] && task.progresses.empty?
      api = Clickatell::API.authenticate(APP_SETTINGS['clickatell']['api'], APP_SETTINGS['clickatell']['user'], APP_SETTINGS['clickatell']['pass'])
      msg = "#{self.login} just passed #{self.task.name}"
      APP_SETTINGS['contacts'].each do |key, number|
        api.send_message(number, msg)
      end
    end
    p = Progress.create(:task => task, :episode => task.episode, :answer => answer, :user => self)
  end

  #returns array of all the teammates a user has
  def teammates
    teammates = User.find(:all, :conditions => ["team = ?", self.team]) unless self.team.empty? || self.team == "Single Player"
    
    return teammates.nil? ? [] : teammates
  end
  
  #checks if the user has a headstart and if it has begun on an episode
  #will crash if the episode previous to the argument episode does not have any tasks
  #TEST
  def headstart_has_begun?(episode)
    
    if episode.start_time - episode.headstart.minutes < Time.now
      
      #just in case this method should be called with the first episode as argument
      if episode.higher_item.nil?
        return false
      end

      p = Progress.find(:first, :conditions => {:user_id => self.id, :task_id => episode.higher_item.tasks.last.id })
      
      if p.position <= episode.headstart_count
        return true
      end
    end
    
    return false
    
  end
  
  #check to see if a user is allowed to access a task
  #TEST this right fucking here
  def validate_task_request?(task_object)
    #if the task object doesnt exist or the episode hasn't been released yet
    if task_object.nil? || (task_object.episode.start_time > Time.now  && !headstart_has_begun?(task_object.episode))
      return false
    end
    
    #if users task is the task requested
    if self.task == task_object
      return true
    end
    
    return false  
  end

  def teaser_winner?
    #did the user give the correct answer?
    if teaser == APP_SETTINGS['teaser']['answer']
      User.find(:all, :order => "created_at ASC").each do |user|
        # find the first use that gave the correct answer
        if user.teaser == APP_SETTINGS['teaser']['answer']
          # is that user this user? if it is, he won, otherwise someone beat him to it
          return user == self
        end
      end
    else
      #didnt give the right answer
      return false
    end
  end

end
