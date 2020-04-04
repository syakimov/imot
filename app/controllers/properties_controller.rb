class PropertiesController < ApplicationController
  def index
    scope = Property.includes(:price_changes).order(:change_in_price, :current_price)

    @properties = params[:changed] ? scope.where.not(change_in_price: 0) : scope.all
  end

  def create
    LoadProperties.execute

    @properties = Property.includes(:price_changes).order(:current_price).all

    render :index
  end
end
