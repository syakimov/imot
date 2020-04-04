module PersistProperties
  class << self
    def execute(imots)
      imots.each do |imot|
        save_property imot
      end
    end

    def save_property(imot)
      property = Property.find_by remote_id: extract_remote_id(imot.link)

      if property.nil?
        property = Property.create!(remote_id: extract_remote_id(imot.link),
                                    current_price: imot.price,
                                    description: imot.description,
                                    change_in_price: 0,
                                    location: imot.location)
      elsif property.current_price != imot.price
        property.update(change_in_price: imot.price - property.current_price, current_price: imot.price)
      end

      last_recorded_change = property.price_changes.order(:id).last
      if last_recorded_change.nil? || last_recorded_change.updated_price != property.current_price
        PriceChange.create! property: property, updated_price: property.current_price
      end
    end

    def extract_remote_id(link)
      # "//www.imot.bg/pcgi/imot.cgi?act=5&adv=1a120585141090062&slink=5crizy&f1=1"
      link.split('adv=').last.split('&').first
    end
  end
end
