class Episode < ActiveRecord::Base
  
  validates_presence_of :name, :start_time, :desc
  
  has_many :tasks
  
  has_many :progresses
  
  acts_as_list
  
  HEAD_COUNT = 10
  
  def before_destroy
    tasks = self.tasks
    tasks.each{|t| t.destroy }
  end
  
  def tasks
    t = Task.find(:all, :conditions => { :episode_id => self.id}, :order => :position)
  end
  
  def progresses
    p = Progress.find(:all, :conditions => { :episode_id => self.id}, :order => :created_at)
  end
  
  
  def get_head_count
    return HEAD_COUNT
  end
  
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
