module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user(if any)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged_in otherwise false
  # User is logged in if current_user is not nil.
  def logged_in?
    return current_user.nil? == false
  end
end
