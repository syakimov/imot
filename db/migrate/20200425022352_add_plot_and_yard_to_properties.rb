class AddPlotAndYardToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :building_plot, :integer
    add_column :properties, :yard, :integer
  end
end
