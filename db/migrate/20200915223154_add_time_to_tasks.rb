class AddTimeToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :time, :integer
  end
end
