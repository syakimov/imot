class Property < ApplicationRecord
  has_many :price_changes

  def imot_link
    "https://www.imot.bg/pcgi/imot.cgi?act=5&adv=#{remote_id}"
  end
end
