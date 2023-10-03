class SessionsController < ApplicationController
  before_action :load_categories
  before_action :load_products

  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params.dig(:session, :password)
      # Log the user in and redirect to the user's show page.
      log_in user
    else
      # Create an error message.
      flash.now[:danger] = "invalid_email_password_combination"
    end
    redirect_to products_path
  end

  def destroy
    log_out
    redirect_to products_url
  end
end
