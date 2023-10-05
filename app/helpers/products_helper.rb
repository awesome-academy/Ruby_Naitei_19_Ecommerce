module ProductsHelper
  def admin?
    current_user.role == "admin"
  end
end
