class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_locale
  include SessionsHelper

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
    @pagy, @products = pagy(Product.ordered_by_name,
                            items: Settings.product_per_page)
  end
end
