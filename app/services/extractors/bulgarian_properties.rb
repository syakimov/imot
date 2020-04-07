module Extractors
  class BulgarianProperties
    attr_reader :properties_count

    def initialize(document)
      @document = document
      @properties_count = adds.size

      if [remote_ids.size, descriptions.size, prices.size, locations.size].uniq.size > 1
        p [remote_ids.size, descriptions.size, prices.size, locations.size]
        raise ParseError, 'There is an error with the parsing'
      end
    end

    def locations
      @locations ||= adds.css('.location').map { |location| location.text.squish }
    end

    def descriptions
      @descriptions ||= adds.css('.title').map { |title| title.text.squish }
    end

    def remote_ids
      @remote_ids ||= adds.css('.title').map { |title| title.attributes['href'].value }
    end

    def prices
      @prices ||=
        adds.map do |add|
          parse_price (add.css('.regular-price') + add.css('.new-price')).last.text
        end
    end

    private

    def adds
      @adds ||= @document.css('.component-property-item')
    end

    def parse_price(raw_price)
      amount = raw_price.split('.').first.tr('^0-9', '').to_i
      if raw_price.include?('€') || raw_price.include?('EUR') || raw_price.include?('$') || raw_price.include?('USD')
        amount * 2
      else
        amount
      end
    end
  end
end
