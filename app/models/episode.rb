class Episode < ActiveRecord::Base
  
  validates_presence_of :name, :start_time, :desc
  has_many :tasks
  has_many :progresses
  acts_as_list
  
  #finds all tasks
  #TODO point of this is? think it has something to do with acts as list, or sorting
  #was off or something, :order => :position should work with normal inheritance too
  #rewove after tests are written
  def tasks
    t = Task.find(:all, :conditions => { :episode_id => self.id}, :order => :position)
  end
  
  #same as above
  def progresses
    p = Progress.find(:all, :conditions => { :episode_id => self.id}, :order => :created_at)
  end
       
end
