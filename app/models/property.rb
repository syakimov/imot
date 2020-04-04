class Property < ApplicationRecord
  has_many :price_changes

  def link
    if remote_id.size > 15
      "https://www.imot.bg/pcgi/imot.cgi?act=5&adv=#{remote_id}"
    else
      "https://www.alo.bg/#{remote_id}"
    end
  end
end
