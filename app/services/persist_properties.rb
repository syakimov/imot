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
      elsif imot.price && property.current_price != imot.price
        property.update(change_in_price: imot.price - property.initial_price, current_price: imot.price)
        PriceChange.create! property: property, updated_price: property.current_price
      end
    rescue
    end

    # TODO: Remove
    def reload_alo_properties
      alo_properties = Property.where('LENGTH(remote_id) = 7')
      alo_properties.each do |property|
        begin
          pp property ;nil
          update_property FetchSingleProperty.execute(property), property
          pp property ;nil
        rescue
        end
      end
    end

    def update_property(fetched_property_data, property)
      update_hash = {}
      update_hash[:current_price] = fetched_property_data.price if fetched_property_data.price
      update_hash[:description] = fetched_property_data.description if fetched_property_data.description
      update_hash[:detailed_description] = fetched_property_data.detailed_description if fetched_property_data.detailed_description

      property.update update_hash
    end
  end
end
