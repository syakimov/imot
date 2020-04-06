class AddStarredToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :starred, :boolean, default: false, null: false
  end
end
