class SessionsController < ApplicationController
  def new
  end

  # This is where user logs in
  def create
    user = User.find_by(email: params[:session][:email])
    
    # If user exists and it's password matches
    # !! -> returns the value in boolean context
    if !!(user && user.authenticate(params[:session][:password]))
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        # Redirect to profile page of user if no friendly forwarding url exists
        redirect_to forwarding_url || user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Create an error message.
      flash.now[:danger] = "Invalid email/password combination"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy

    # Two separate tabs logouts to be a problem.
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
