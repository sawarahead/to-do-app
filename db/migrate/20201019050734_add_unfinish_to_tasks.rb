class AddUnfinishToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :unfinish, :integer
  end
end
