class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    
    # If user exists and it's password matches
    # !! -> returns the value in boolean context
    if !!(user && user.authenticate(params[:session][:password]))
      forwarding_url = session[:forwarding_url]

      reset_session
      # This removes forwading url from session which is important because otherwise subsequent login attempts would forward to the protected page until the user closed their browser.
      
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user

      # Redirect to profile page of user if no friendly forwarding url exists
      redirect_to forwarding_url || user
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
