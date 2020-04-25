require 'open-uri'

module FetchSingleProperty
  class << self
    def execute(url)
      p "Fetching url: #{url}"

      begin
        Nokogiri::HTML(open(url))
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end
