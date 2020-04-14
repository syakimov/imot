module Extractors
  class SinglePropertyExtractor
    attr_reader :price, :description, :detailed_description

    def initialize(domain, document)
      case domain
      when Property::IMOTBG
        imotbg_setup document
      when Property::ALO
        alo_setup document
      when Property::BULGARIAN_PROPERTIES
        bulgarian_properties_setup
      end
    end

    def alo_setup(document)
      @price = PriceParser.execute document.css('#price_name + .ads-params-price')&.text
      @description = document.css('.large-headline')&.text&.squish
      @detailed_description = document.css('.word-break-all')&.text&.squish
    end

    def imotbg_setup(document)
      raise 'Not implemented error'
    end

    def bulgarian_properties_setup(document)
      raise 'Not implemented error'
    end
  end
end
