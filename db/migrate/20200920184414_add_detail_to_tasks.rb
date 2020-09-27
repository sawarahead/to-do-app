class AddDetailToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :detail, :text
  end
end
