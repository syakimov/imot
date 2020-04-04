module Extractors
  class ParseError < StandardError
  end

  class Alo
    attr_reader :properties_count, :remote_ids, :prices, :descriptions, :locations

    def initialize(document)
      @document = document

      @remote_ids = raw_links.map {|raw_link| extract_remote_id(raw_link.attributes['href'].value) }
      @locations = raw_locations.map { |l| l.children.children.last.text }
      @prices = raw_prices.map { |raw_price| parse_price(raw_price) }
      @descriptions = document.css('.listvip-desc').map { |raw_description| raw_description.children.last.text }
      @properties_count = remote_ids.size

      if [remote_ids.size, descriptions.size, prices.size, locations.size].uniq.size > 1
        p [remote_ids.size, descriptions.size, prices.size, locations.size]
        raise ParseError, 'There is an error with the parsing'
      end
    end

    def raw_links
      @document.css('.listvip-params .listvip-item-header a')
    end

    def raw_locations
      @document.css('.listvip-params .listvip-item-header .listvip-item-address')
    end

    def raw_prices
      @document.css('.listvip-params .listvip-item-content').map do |price_wrapper|
        price_wrapper.css("span[title='Цена'] .ads-param-name + .nowrap")&.children&.last&.text || '1'
      end
    end

    def raw_properties
      @document.css('.listvip-params .listvip-item-header')
    end

    def extract_remote_id(link)
      link[1..7]
    end

    def parse_price(price)
      amount = price.split('.').first.tr('^0-9', '').to_i
      if price.include?('EUR') || price.include?('$') || price.include?('USD')
        amount * 2
      else
        amount
      end
    end
  end
end
