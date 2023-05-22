class ItemsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, status: :ok
  end

  def create 
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create!(items_params)
      render json: item, status: :created
    end
  end



  private

  def render_not_found(e)
    render json: {error: e.message }, status: :not_found
  end

  def render_invalid(e)
    render json: {error: e.message }, status: :unprocessable_entity
  end

  def items_params
    params.permit(:name, :description, :price, :id, :user_id)
  end

end
