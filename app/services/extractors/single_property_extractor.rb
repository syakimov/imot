module Extractors
  class SinglePropertyExtractor
    attr_reader :price, :description, :detailed_description, :building_plot, :yard

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
      @building_plot = find_param(document, 'кв.м РЗП')
      @yard = find_param(document, 'кв.м двор')
    end

    def imotbg_setup(document)
      raise 'Not implemented error'
    end

    def bulgarian_properties_setup(document)
      raise 'Not implemented error'
    end

    private

    def find_param(document, param_match)
      raw = document.css('.ads-params-single').find { |a| a.text && a.text.ends_with?(param_match) }
      extracted = raw&.text&.tr('^0-9', '').to_i
      extracted.zero? ? nil : extracted
    end
  end
end
