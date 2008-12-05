class Episode < ActiveRecord::Base
  
  validates_presence_of :name, :start_time, :desc
  
  has_many :tasks
  
  has_many :progresses
  
  acts_as_list
  
  HEAD_COUNT = 10
  
  #Destroys all the tasks on the episode
  def before_destroy
    tasks = self.tasks
    tasks.each{|t| t.destroy }
  end
  
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
  
  #TODO wtf is this? remove!
  def get_head_count
    return HEAD_COUNT
  end
  
  #alias for .last?
  #TODO remove from code completely
  def is_last?
    self.last?
    # eps = Episode.find_by_sql("select * from episodes ORDER BY position DESC LIMIT 1")
    # if self.position == eps.first.position
    #   true
    # else
    #   false
    # end
  end
      
      
end
