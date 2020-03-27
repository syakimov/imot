class Property < ApplicationRecord
  has_many :price_changes

  def imot_link
    "https://www.imot.bg/pcgi/imot.cgi?act=5&adv=#{remote_id}"
  end

  def change_in_price
    previous_price = price_changes.where.not(updated_price: current_price).order(:id).last
    return 0 unless previous_price

    current_price - previous_price
  end
end
