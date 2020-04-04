class AddTimestampsToPriceChanges < ActiveRecord::Migration[5.2]
  def change
    add_column :price_changes, :created_at, :datetime
    add_column :price_changes, :updated_at, :datetime
  end
end
