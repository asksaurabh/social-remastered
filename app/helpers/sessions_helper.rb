module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # remembers a user in a persistent session(if not logged out)
  def remember(user)

    # Sets the remember token for curr user and updates the remember_digest
    user.remember       

    # Puts the id and token in the browser cookie.
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged-in user(if any)
  def current_user
    # If their is someone in the temp session(means browser not closed yet)
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    
    # Otherwise look if someone was already logged-in(look in permanent cookie)
    elsif cookies.encrypted[:user_id]
      user = User.find_by(id: cookies.encrypted[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged_in otherwise false
  # User is logged in if current_user is not nil.
  def logged_in?
    return current_user.nil? == false
  end

  # Forgets a permanent session(deletes the persistent cookies)
  def forget(user)
    user.forget      # Set its remember digest to nil
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user
  def log_out
    # session[:user_id] = nil
    # session.delete(:user_id)
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
