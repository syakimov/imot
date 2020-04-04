require 'open-uri'

module FetchProperties
  class Imot
    attr_reader :remote_id, :price, :description, :location

    def initialize(link:, price:, description:, location:)
      @remote_id = extract_remote_id link
      @price = price
      @description = description
      @location = location
    end

    def extract_remote_id(link)
      # "//www.imot.bg/pcgi/imot.cgi?act=5&adv=1a120585141090062&slink=5crizy&f1=1"
      link.split('adv=').last.split('&').first
    end
  end

  class << self
    def execute(url)
      page = 1

      properties = []

      while true
        fetched_properties = fetch_properties_from_page("#{url}#{page}")
        break if fetched_properties.size == 0

        properties += fetched_properties
        page += 1
      end

      properties
    end

    def fetch_properties_from_page(url)
      document = Nokogiri::HTML(open(url))

      links = document.css('.price + br + a')
      locations = document.css('.price + br + a + br + a')
      prices = parse_prices document.css('.price').map(&:text)

      properties = []

      links.size.times do |i|
        properties << Imot.new(link: links[i].attributes['href'].value,
                               description: links[i].children.last&.text,
                               location: locations[i]&.children&.last&.text,
                               price: prices[i])
      end

      properties
    end

    def parse_prices(prices_as_text)
      prices_as_text.map do |price|
        amount = price.gsub(' ', '').to_i
        if price.include?('EUR') || price.include?('$') || price.include?('USD')
          amount * 2
        else
          amount
        end
      end
    end
  end
end
