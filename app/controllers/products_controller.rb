class ProductsController < ApplicationController
  before_action :set_product, only: %i(show edit update destroy)
  before_action :load_categories
  before_action :load_products
  require "pagy/extras/array"

  # GET /products or /products.json
  def index; end

  # GET /products/1 or /products/1.json
  def show
    @images = @product.product_images
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html do
          redirect_to product_url(@product),
                      notice: "Product was successfully created."
        end
        format.json{render :show, status: :created, location: @product}
      else
        format.html{render :new, status: :unprocessable_entity}
        format.json do
          render json: @product.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html do
          redirect_to product_url(@product),
                      notice: "Product was successfully updated."
        end
        format.json{render :show, status: :ok, location: @product}
      else
        format.html{render :edit, status: :unprocessable_entity}
        format.json do
          render json: @product.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html do
        redirect_to products_url,
                    notice: "Product was successfully destroyed."
      end
      format.json{head :no_content}
    end
  end

  def cart; end

  def filter
    filtered_products = Product.joins(:category)
                               .merge(Category.by_name(params[:category]))
    @pagy, @products = pagy(filtered_products,
                            items: Settings.product_per_page)
    render template: "products/index"
  end

  def search
    searched_products = Product.all
    searched_products = filter_name searched_products, params[:name]
    searched_products = filter_category searched_products, params[:category]
    if params[:price]
      searched_products = filter_price searched_products,
                                       params[:price]
    end
    @pagy, @products = pagy_array(searched_products,
                                  items: Settings.product_per_page)
    render template: "products/search" and return
  end

  def render_search_page
    render "products/search"
  end

  def add_to_cart; end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find_by id: params[:id]
  end

  def set_categories
    @categories = Category.all
  end

  def load_categories
    @categories = Category.ordered_by_name
  end

  def load_products
    @pagy, @products = pagy(Product.ordered_by_name,
                            items: Settings.product_per_page)
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :price, :description, :category_id)
  end

  def filter_name products, name
    if name
      products = products.select do |product|
        product.name.include?(name)
      end
    end
    products
  end

  def filter_category products, category
    if category
      products = products.select do |product|
        Category.find_by(id: product.category_id).name == category
      end
    end
    products
  end

  def filter_price products, price
    if price == "<1tr"
      products.select do |product|
        product.price < 1_000_000
      end
    elsif price == ">5tr"
      products.select do |product|
        product.price > 5_000_000
      end
    else
      products.select do |product|
        product.price < 5_000_000 && product.price > 1_000_000
      end
    end
  end
end
