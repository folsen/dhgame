class Task < ActiveRecord::Base
  
  validates_presence_of :name, :desc
  
  acts_as_list :scope => :episode_id
  
  belongs_to :episode
  
  has_many :materials
  has_many :answers
  has_many :progresses
  
  #for creating attached material
  def material_attributes=(material_attributes)
    material_attributes.each do |attributes|
      materials.build(attributes)
    end
  end
  
  #alias for .last?
  #TODO remove from code completely
  def is_last?
    self.last?
    # if self == self.episode.tasks.last
    #   true
    # else
    #   false
    # end
  end
  
  #returns the id of the first task of the first episode
  def self.get_first_task_id
     firsts = Task.find_all_by_position(1)
     firsts.each do |t|
       if t.episode.position == 1
         return t.id
       end
     end
   end
  
  #TODO rewrite, check to see if this is a list and perhaps replace 
  #episode.tasks.last with is_last? or just last?
  #probably should remove all instances of this
  #it is used to get the next task when you've supplied a correct answer
  def next_task
    if last?
      return self.episode.lower_item.tasks.first
    else
      return self.lower_item
    end
  end
  
  #check to see if user_answer is the correct answer for the question
  #TODO implement the hashing feature somehow
  def check_answer(user_answer)
    self.answers.each do |answer|
      if answer.answer == user_answer
        return true
      end
    end
      return false
  end
  
end
