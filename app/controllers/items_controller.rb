class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  def index
    if params[:user_id]
    user = finduser
    item = user.items
  else
    item = Item.all
  end
  render json: item, include: :user
  end

  def show 
    item = finditem
    render json: item, include: :user
  end


  def create
    user = finduser
    item = user.items.create(permit_params)
    render json: item, status: :created
  end


  private
  def finduser
    User.find(params[:user_id])
  end
  def finditem
    Item.find(params[:id])
  end
  def permit_params
    params.permit(:name, :description, :price)
  end
  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end
end
