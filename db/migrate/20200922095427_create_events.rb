class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.text :content
      t.integer :place
      t.datetime :start_time
      t.datetime :end_time
      t.text :detail
      t.integer :repeat

      t.timestamps
    end
  end
end
