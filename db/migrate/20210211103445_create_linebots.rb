class CreateLinebots < ActiveRecord::Migration[5.2]
  def change
    create_table :linebots do |t|

      t.timestamps
    end
  end
end
