class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.search_merchant(params[:name])
    if merchant == nil
      render json: { "data": {} }, status: 200
    else
      render json: MerchantSerializer.new(merchant)
    end 
  end
end