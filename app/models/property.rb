class Property < ApplicationRecord
  has_many :price_changes

  def link
    if remote_id.include? 'bulgarianproperties'
      remote_id
    elsif from_imotbg?
      "https://www.imot.bg/pcgi/imot.cgi?act=5&adv=#{remote_id}"
    else
      "https://www.alo.bg/#{remote_id}"
    end
  end

  def formatted_description
    return description if from_imotbg?

    case description.downcase
    when /ъща/ then 'Продава КЪЩА'
    when /ъщи/ then 'Продава КЪЩА'
    when /арцел/ then 'Продава ПАРЦЕЛ'
    when /ила/ then 'Продава ВИЛА'
    else description.first(20)
    end
  end

  def from_imotbg?
    remote_id.size > 15
  end
end
