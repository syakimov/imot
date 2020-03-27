class CreatePriceChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :price_changes do |t|
      t.belongs_to :property, foreign_key: {on_delete: :cascade}, null: false
      t.integer :updated_price, null: false
    end
  end
end
