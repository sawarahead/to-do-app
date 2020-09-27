class AddPlaceDetailToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :place_detail, :string
  end
end
