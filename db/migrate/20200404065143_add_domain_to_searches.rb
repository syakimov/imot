class AddDomainToSearches < ActiveRecord::Migration[5.2]
  def change
    add_column :searches, :domain, :string
  end
end
