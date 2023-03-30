class Api::V1::Item::MerchantsController < ApplicationController
  
  def show
    merchant = Item.find(params[:item_id]).merchant
    render json: MerchantSerializer.new(merchant)
  end
  
end