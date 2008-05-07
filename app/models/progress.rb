class Progress < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :episode
  belongs_to :task
  
  acts_as_list :scope => :task_id
  
end
