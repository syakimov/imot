class PropertiesController < ApplicationController
  def index
    @properties = Property.includes(:price_changes).order(:current_price).all
  end

  def create
    PersistProperties.execute(FetchProperties.execute)

    @properties = Property.includes(:price_changes).order(:current_price).all

    render :index
  end
end
