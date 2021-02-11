class Linebot < ApplicationRecord

  def getTodayUnfinishedTasks(today)
      return Task.where(date:today).where(check:0)
      #.where(user_id:self.id).pluck(:content)
      #task_list=""
      #tasks.each do |task|
      #    task_list += "・#{task}\n"
    #  end
      #return task_list
  end
end
