class CreatePropertiesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.string :description
      t.string :location
      t.integer :current_price
      t.integer :change_in_price
      t.string :remote_id, index: {unique: true}, null: false
      t.boolean :watched

      t.timestamps
    end
  end
end
