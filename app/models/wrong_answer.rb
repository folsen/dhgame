class WrongAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  
  after_create :remove_old
  
  cattr_reader :per_page
  @@per_page = 100
  
  #to prevent storing way to much crap only store the latest 100 wrong answers
  def remove_old
    count = WrongAnswer.count(:all, :conditions => { :user_id => user.id })
    if count > APP_SETTINGS['wrong_answers_to_store']
      WrongAnswer.find(:first, :conditions => { :user_id => user.id }).destroy
    end
  end
end
