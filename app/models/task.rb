class Task < ActiveRecord::Base
  
  validates_presence_of :name, :desc
  
  acts_as_list :scope => :episode_id
  
  belongs_to :episode
  has_many :users
  
  has_many :materials, :dependent => :destroy
  has_many :answers, :dependent => :destroy
  has_many :progresses, :dependent => :destroy
  
  after_update :save_answers

  def new_material_attributes=(material_attributes)
    material_attributes.each do |attributes|
      materials.build(attributes)
    end
  end
  
  def existing_material_attributes=(material_attributes)
    materials.reject(&:new_record?).each do |material|
      if !material_attributes[material.id.to_s]
        materials.delete(material)
      end
    end
  end
  
  def new_answer_attributes=(answer_attributes)
    answer_attributes.each do |attributes|
      answers.build(attributes)
    end
  end
  
  def existing_answer_attributes=(answer_attributes)
    answers.reject(&:new_record?).each do |answer|
      attributes = answer_attributes[answer.id.to_s]
      if attributes
        answer.attributes = attributes
      else
        answers.delete(answer)
      end
    end
  end
  
  def save_answers
    answers.each do |answer|
      answer.save(false)
    end
  end
  
  #returns the id of the first task of the first episode
  #TODO refactor with some sql or something
  def self.first_task
    e = Episode.find_by_position(1)
    t = Task.find(:first, :conditions => {:position => 1, :episode_id => e.id})
    return t
   end
  
  #it is used to get the next task when you've supplied a correct answer
  #TEST
  def next_task
    if last?
      return self.episode.lower_item.tasks.first unless self.episode.lower_item.nil?
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
