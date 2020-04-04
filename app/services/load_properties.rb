module LoadProperties
  SEARCHES = {
    parceli_v_sredec: 'https://www.imot.bg/pcgi/imot.cgi?act=3&slink=5cuf6y&f1=',
    kushti_v_sredec: 'https://www.imot.bg/pcgi/imot.cgi?act=3&slink=5cug6q&f1=',
  }

  class << self
    def execute
      Search.pluck(:url).each do |search_url|
        PersistProperties.execute(FetchProperties.execute(search_url))
      end
    end
  end
end
