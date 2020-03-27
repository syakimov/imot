require 'open-uri'

module FetchProperties
  SEARCHES = {
    burgas: 'https://www.imot.bg/pcgi/imot.cgi?act=3&slink=5crizy&f1='
  }

  class Imot
    attr_reader :link, :price, :description, :location

    def initialize(link:, price:, description:, location:)
      @link = link
      @price = price
      @description = description
      @location = location
    end
  end

  class << self
    def execute
      url = 'https://www.imot.bg/pcgi/imot.cgi?act=3&slink=5crizy&f1='
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
        if price.include? 'EUR'
          amount * 2
        else
          amount
        end
      end
    end
  end
end
