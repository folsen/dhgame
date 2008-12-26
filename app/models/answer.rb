class Answer < ActiveRecord::Base
  #this model saves all the passwords for all the tasks
  #passwords should not be saved in clear text
  #TODO hash passwords
  belongs_to :task
end
