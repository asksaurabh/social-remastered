module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user(if any)
  def current_user
    if @current_user.nil?
      # Save the current user and returns it to avoid finding current loggedin user again and again
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
  end
end
