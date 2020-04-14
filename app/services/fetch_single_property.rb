require 'open-uri'

module FetchSingleProperty
  class << self
    def execute(property)
      value_object = fetch property.domain, property.link
    end

    def fetch(domain, url)
      p "Fetching url: #{url}"

      document =
        begin
          Nokogiri::HTML(open(url))
        rescue OpenURI::HTTPError
          nil
        end

      return nil unless document

      Extractors::SinglePropertyExtractor.new domain, document
    end
  end
end
