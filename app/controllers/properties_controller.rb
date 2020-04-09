class PropertiesController < ApplicationController
  def index
    @properties = properties
  end

  def mark_as_seen
    property = Property.find params[:id]
    property.update(seen: true)
  end

  def mark_as_starred
    property = Property.find params[:id]
    property.update(starred: !property.starred)
  end

  private

  def properties
    scope =
      Property.
        order(starred: :desc,
              change_in_price: :asc,
              current_price: :asc, )

    scope = scope.where("current_price >= #{params[:from] || 10}")
    scope = scope.where("current_price <= #{params[:to] || 100000}")
    scope = scope.where(seen: false) unless params[:include_seen]

    scope = scope.where("description LIKE '%#{params[:d]}%'") if params[:d]
    scope = scope.where("location LIKE '%#{params[:l]}%'") if params[:l]

    scope = scope.where.not(change_in_price: 0) if params[:changed_only]
    filtered_properties = scope.all

    filtered_properties = filtered_properties.select { |prop| !prop.formatted_description.include? 'ПАРЦЕЛ' } if params[:without_land]
    filtered_properties = filtered_properties.select { |prop| !prop.formatted_description.include? 'СТАЕН' } if params[:without_appartments]

    filtered_properties = filtered_properties.first(100) unless params[:show_all]

    filtered_properties
  end
end
