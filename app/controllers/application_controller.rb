class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_locale
  include SessionsHelper
  include ProductsHelper

  private
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_categories
    @categories = Category.ordered_by_name
  end

  def load_products
    @pagy, @products = pagy(Product.ordered_by_name.select("*")
                                    .joins(:category),
                            items: Settings.product_per_page)
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = "Please log in."
    redirect_to products_path
  end

  def check_admin
    return if admin?

    flash[:danger] = "You don't have permission to access"
    redirect_to products_path
  end
end
