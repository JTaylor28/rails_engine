class Api::V1::ItemsController < ApplicationController
  
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.new(item_params)
    if item.save
    render json: ItemSerializer.new(item), status: 201
    else
      render json: {
                    message: "item was not created. Attributes must be valid",
                    errors: item.errors.full_messages.join(', ')
                  }, status: :bad_request
    end 
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item), status: 201
    else
      render json: {
                    "message": "your query could not be completed",
                    "errors": "Merchant ID doesn't exist"
                  }, status: 404 
    end
  end

  def destroy
    render json: Item.delete(params[:id]), status: 204
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end