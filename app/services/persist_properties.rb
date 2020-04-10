module PersistProperties
  class << self
    def execute(imots)
      imots.each do |imot|
        save_property imot
      end
    end

    def save_property(imot)
      property = Property.find_by remote_id: imot.remote_id

      if property.nil?
        property = Property.create!(remote_id: imot.remote_id,
                                    current_price: imot.price,
                                    description: imot.description,
                                    change_in_price: 0,
                                    location: imot.location)
      elsif property.current_price != imot.price
        property.update(change_in_price: imot.price - property.initial_price, current_price: imot.price)
        PriceChange.create! property: property, updated_price: property.current_price
      end
    end
  end
end
