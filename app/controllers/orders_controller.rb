class OrdersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :load_orders, only: :index
  before_action :load_order, only: [:show, :destroy]
  before_action :load_products, only: :show
  before_action :load_images, only: :show

  def index; end

  def show; end

  def destroy
    @order.destroy
    flash[:notice] = "Cancel order successfully"
    redirect_to orders_path
  end

  private
  def load_orders
    @orders = Order.by_user_id(current_user.id).where.not(order_status: 0)
  end

  def load_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:alert] = "Order doesn't exist"
    redirect_to products_path
  end

  def load_products
    if current_user
      @products = Product.select("*").joins(:orders).merge(Order.by_id(params[:id]))
    else
      redirect_to products_url
    end
  end

  def load_images
    if current_user
      @images = @products.joins(:product_images)
    else
      redirect_to products_url
    end
  end
end
