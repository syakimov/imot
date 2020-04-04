require 'open-uri'

module FetchProperties
  class PropertyValueObject
    attr_reader :remote_id, :price, :description, :location

    def initialize(remote_id:, price:, description:, location:)
      @remote_id = remote_id
      @price = price
      @description = description
      @location = location
    end
  end

  class << self
    def execute(search)
      page = 1

      properties = []

      while true
        fetched_properties = fetch_properties_from_page(search.domain, "#{search.url}#{page}")
        break if fetched_properties.size == 0

        properties += fetched_properties
        page += 1
      end

      properties
    end

    def fetch_properties_from_page(domain, url)
      p "Fetching url: #{url}"
      document = Nokogiri::HTML(open(url))

      extractor =
        if domain == 'imotbg'
          Extractors::Imotbg.new document
        else
          raise 'Not expected domain'
        end

      properties = []

      extractor.properties_count.times do |i|
        properties << PropertyValueObject.new(remote_id: extractor.remote_ids[i],
                                              description: extractor.descriptions[i],
                                              location: extractor.locations[i],
                                              price: extractor.prices[i])
      end

      properties
    end
  end
end
