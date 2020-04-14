class AddDetailedDescriptionToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :detailed_description, :string, index: true
  end
end
