class Task < ActiveRecord::Base
  
  validates_presence_of :name, :desc
  
  acts_as_list :scope => :episode_id
  
  belongs_to :episode
  
  has_many :answers
  
  has_many :progresses
  
  def is_last?
    self.last?
    # if self == self.episode.tasks.last
    #   true
    # else
    #   false
    # end
  end
  
  def self.get_first_task_id
     firsts = Task.find_all_by_position(1)
     firsts.each do |t|
       if t.episode.position == 1
         return t.id
       end
     end
   end
  
  def self.get_id_for_task(task_object)
    if task_object.episode.tasks.last == task_object
      return task_object.episode.higher_item.tasks.first.id
    else
      return task_object.lower_item.id
    end
  end
  
  def self.validate_task_request?(task_object, user_object)
    #if the task object exists and it's past it's start time
    if !task_object.nil? && (task_object.episode.start_time < Time.now  || User.has_headstart(task_object.episode, user_object))
      progress = user_object.progresses #get the users progresses into progress
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
    else
      #the task has not been released yet or the task doesnt exist
      logger.debug("Fuck you false")
      return false
    end
  end
  
  def check_answer(user_answer)
    self.answers.each do |answer|
      if answer.answer == user_answer
        return true
      else
        next
      end
    end
    false
  end
  
end
