class AddInitialPriceToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :initial_price, :integer
  end
end
