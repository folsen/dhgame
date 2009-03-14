class Episode < ActiveRecord::Base
  
  validates_presence_of :name, :start_time, :desc
  has_many :tasks, :order => "position"
  has_many :progresses, :order => "created_at"
  acts_as_list
       
end
