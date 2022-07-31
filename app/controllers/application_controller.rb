class ApplicationController < ActionController::Base

  include SessionsHelper

  # Before filters
  # Confirms if the user is logged-in or not
  def logged_in_user
    if logged_in? == false
      store_location   # Capture the current state.(SessionHelper)
      flash[:danger] = "Please log in"
      redirect_to login_url, status: :see_other
    end
  end
end
