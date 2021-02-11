class Task < ApplicationRecord
    validates :content, {presence: true}
    validates :time, {presence: true}
    validates :repeat, {presence: true}
    validates :date, {presence: true}

    def getTodayUnfinishedTasks(date)
        tasks=Task.where(date:date).where(check:0).where(user_id:self.id).pluck(:content)
        task_list=""
        tasks.each do |task|
            task_list += "・#{task}\n"
        end
        return task_list
    end
end
