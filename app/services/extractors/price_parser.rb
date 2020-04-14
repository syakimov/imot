module Extractors
  module PriceParser
    extend self

    def execute(price)
      amount = price.split('.').first.tr('^0-9', '').to_i

      if price.include?('EUR') || price.include?('$') || price.include?('USD')
        amount * 2
      else
        amount
      end
    end
  end
end
