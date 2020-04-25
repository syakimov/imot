module PersistProperties
  class << self
    def execute(fetched_data_collection)
      fetched_data_collection.each do |fetched_property_data|
        save_property fetched_property_data
      end
    end

    def save_property(fetched_property_data)
      property = Property.find_by remote_id: fetched_property_data.remote_id

      if property.nil?
        property = Property.create!(remote_id: fetched_property_data.remote_id,
                                    current_price: fetched_property_data.price,
                                    description: fetched_property_data.description,
                                    change_in_price: 0,
                                    location: fetched_property_data.location)
      elsif fetched_property_data.price && property.current_price != fetched_property_data.price
        property.update(change_in_price: fetched_property_data.price - property.initial_price, current_price: fetched_property_data.price)
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
          document = FetchSingleProperty.execute property.link
          data = Extractors::SinglePropertyExtractor.new property.domain, document
          update_property data, property
          pp property ;nil
        rescue
        end
      end
    end

    def update_property(fetched_property_data, property)
      update_hash = {}
      if fetched_property_data.price && property.current_price != fetched_property_data.price
        update_hash[:current_price] = fetched_property_data.price
        update_hash[:change_in_price] = fetched_property_data.price - property.initial_price
      end
      update_hash[:description] = fetched_property_data.description if fetched_property_data.description
      update_hash[:detailed_description] = fetched_property_data.detailed_description if fetched_property_data.detailed_description
      update_hash[:building_plot] = fetched_property_data.building_plot if fetched_property_data.building_plot
      update_hash[:yard] = fetched_property_data.yard if fetched_property_data.yard

      property.update update_hash
    end
  end
end
