class Api::V1::Merchant::ItemsController < ApplicationController
  
  def index
    item = Merchant.find(params[:merchant_id]).items
    render json: ItemSerializer.new(item)
  end

end