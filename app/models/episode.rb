class Episode < ActiveRecord::Base
  
  validates_presence_of :name, :start_time, :desc
  has_many :tasks, :order => "position", :dependent => :destroy
  has_many :progresses, :order => "created_at", :dependent => :destroy
  acts_as_list
       
end
