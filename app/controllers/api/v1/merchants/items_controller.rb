class Api::V1::Merchants::ItemsController < ApplicationController
  
  def index
    item = Merchant.find(params[:merchant_id]).items
    render json: ItemSerializer.new(item)
  end

end