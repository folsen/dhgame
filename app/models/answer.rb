#this table saves all the passwords for all the tasks
#passwords should not be saved in clear text
#TODO hash passwords

class Answer < ActiveRecord::Base
  validates_presence_of :answer
  
  belongs_to :task
  
  has_many :progress
  
  def before_save
    self.answer = self.answer.downcase
    if self.answer == ''
      self.answer = "gioehafiähafnavnvbeoighaoåiwhfaincalcnalksvndlvbdo"
    end
  end
  
end
