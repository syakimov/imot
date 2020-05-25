module Extractors
  class Olx
    attr_reader :properties_count

    def initialize(document)
      @document = document
      @properties_count = prices.size

      if [remote_ids.size, descriptions.size, prices.size, locations.size].uniq.size > 1
        p [remote_ids.size, descriptions.size, prices.size, locations.size]
        raise ParseError, 'There is an error with the parsing'
      end
    end

    def locations
      @locations ||=
        @document.css('.bottom-cell p').map do |paragraph|
          paragraph.css('span').first.children.last.text.squish
        end
    end

    def descriptions
      @descriptions ||= @document.css('.title-cell h3 a').map { |a| a.children[1].text.squish }
    end

    def remote_ids
      @remote_ids ||= @document.css('.title-cell h3 a').map { |a| a.attributes['href'].value }
    end

    def prices
      @prices ||=
        begin
          @document.css('td.td-price .price').map do |node|
            PriceParser.execute node.children[1].children.first.text
          end
        end
    end
  end
end
