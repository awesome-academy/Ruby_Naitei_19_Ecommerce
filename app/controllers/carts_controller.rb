class CartsController < ApplicationController
  before_action :logged_in_user
  before_action :load_cart_products
  before_action :load_images
  before_action :load_products, only: [:add_to_cart]
  before_action :load_categories, only: [:add_to_cart]

  def show; end

  def update
    order = OrderProduct.joins(:order)
                        .merge(Order.by_user_id(current_user.id).in_cart)
                        .by_product_id(params[:product_id])
    initial = order[0].order_quantity
    order.update(order_quantity: params[:plus] ? initial + 1 : initial - 1)
    handle_ajax cart_path
  end

  def remove_from_cart
    order = OrderProduct.find_by(product_id: params[:product_id],
                                 order_id: params[:order_id])
    order.destroy
    unless OrderProduct.find_by(order_id: params[:order_id])
      Order.find_by(id: params[:order_id]).destroy
    end
    handle_ajax cart_path
  end

  def add_to_cart
    order = Order.by_user_id(current_user.id).in_cart
    handle_add_cart order
    flash[:notice] = "Added successfully"
    render "products/index"
  end

  def checkout
    @products.each do |product|
      if product.order_quantity > product.number
        flash[:alert] = "There are only #{product.number} #{product.name} left"
        redirect_to cart_path and return
      end
    end
    flash[:notice] = "Order created successfully, waiting for admin"
    Order.find_by(id: params[:order_id]).update(order_status: 1)
    redirect_to products_path
  end

  private
  def load_cart_products
    if current_user
      @products = Product.select("*")
                         .joins(:orders)
                         .merge(Order.by_user_id(current_user.id).in_cart)
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

  def handle_ajax path
    respond_to do |format|
      format.html{redirect_to path}
      format.js
    end
  end

  def handle_add_cart order
    if order.empty?
      new_order = Order.create(user_id: current_user.id, order_status: 0,
                               total_price: 0)
      OrderProduct.create(order_id: new_order.id,
                          product_id: params[:product_id], order_quantity: 1)
    elsif OrderProduct.find_by(product_id: params[:product_id])
      update "plus"
    else
      OrderProduct.create(order_id: order[0].id,
                          product_id: params[:product_id],
                          order_quantity: 1, product_price: 0)
    end
  end
end
