class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.search_item(params[:name])
    if items == nil
      render json: { "data": [] }, status: 200
    else
      render json: ItemSerializer.new(items)
    end 
  end
end

private

# if params[:name].present? && params[:min_price].present? || params[:max_price].present?
  # render_bad_request_response(exception)