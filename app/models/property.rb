class Property < ApplicationRecord
  ALO = 'alo'
  IMOTBG = 'imotbg'
  BULGARIAN_PROPERTIES = 'BulgarianProperties'

  has_many :price_changes

  def link
    case domain
    when IMOTBG then "https://www.imot.bg/pcgi/imot.cgi?act=5&adv=#{remote_id}"
    when ALO then "https://www.alo.bg/#{remote_id}"
    else remote_id
    end
  end

  def formatted_description
    return description if domain == IMOTBG

    case description.downcase
    when /ъща/ then 'Продава КЪЩА'
    when /ъщи/ then 'Продава КЪЩА'
    when /арцел/ then 'Продава ПАРЦЕЛ'
    when /ила/ then 'Продава ВИЛА'
    else description.first(20)
    end
  end

  def domain
    if remote_id.include? 'bulgarianproperties'
      BULGARIAN_PROPERTIES
    elsif remote_id.size > 15
      IMOTBG
    else
      ALO
    end
  end
end
