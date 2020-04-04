module Extractors
  class Imotbg
    attr_reader :properties_count, :remote_ids, :prices, :descriptions, :locations

    def initialize(document)
      raw_links = document.css('.price + br + a')

      @remote_ids   = raw_links.map {|raw_link| extract_remote_id(raw_link.attributes['href'].value) }
      @descriptions = raw_links.map {|raw_link| raw_link.children.last&.text }
      @prices = document.css('.price').map(&:text).map {|raw_price| parse_price(raw_price) }
      @locations = document.css('a.lnk2').map {|raw_location| raw_location&.children&.last&.text }

      if [remote_ids.size, descriptions.size, prices.size, locations.size].uniq.size > 1
        p [remote_ids.size, descriptions.size, prices.size, locations.size]
        raise 'There is an error with the parsing'
      else
        @properties_count = remote_ids.size
      end
    end

    private

    def extract_remote_id(link)
      # "//www.imot.bg/pcgi/imot.cgi?act=5&adv=1a120585141090062&slink=5crizy&f1=1"
      link.split('adv=').last.split('&').first
    end

    def parse_price(price)
      amount = price.gsub(' ', '').to_i
      if price.include?('EUR') || price.include?('$') || price.include?('USD')
        amount * 2
      else
        amount
      end
    end
  end
end
