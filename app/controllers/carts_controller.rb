class CartsController < ApplicationController
  before_action :load_cart_products
  before_action :load_images
  before_action :load_products, only: [:add_to_cart]
  before_action :load_categories, only: [:add_to_cart]

  def show; end

  def update
    order = OrderProduct.joins(:order).merge(Order.by_user_id(current_user.id).in_cart).by_product_id(params[:product_id])
    order.update(order_quantity: params[:plus] ? order[0].order_quantity + 1 : order[0].order_quantity - 1)
    respond_to do |format|
      format.js
      format.html { redirect_to cart_path }
    end
  end

  def remove_from_cart
    order = OrderProduct.find_by(product_id: params[:product_id], order_id: params[:order_id])
    order.destroy
    if !OrderProduct.find_by(order_id: params[:order_id])
      Order.find_by(id: params[:order_id]).destroy
    end
    respond_to do |format|
      format.js
      format.html { redirect_to cart_path }
    end
  end

  def add_to_cart
    order = Order.by_user_id(current_user.id).in_cart
    if order.empty?
      new_order = Order.create(user_id: current_user.id, order_status: 0,
                               total_price: 0)
      OrderProduct.create(order_id: new_order.id,
                          product_id: params[:product_id], order_quantity: 1)
    elsif OrderProduct.find_by(product_id: params[:product_id])
      update "plus"
    else
      OrderProduct.create(order_id: order[0].id,
                          product_id: params[:product_id], order_quantity: 1, product_price: 0)
    end
    render "products/index"
  end

  private
  def load_cart_products
    if current_user
      @products = Product.select("*").joins(:orders).merge(Order.by_user_id(current_user.id).in_cart)
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
