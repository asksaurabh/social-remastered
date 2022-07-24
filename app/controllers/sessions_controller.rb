class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    
    # If user exists and it's password matches
    # !! -> returns the value in boolean context
    if !!(user && user.authenticate(params[:session][:password]))
      # Redirect to profile page of the user
      reset_session
      log_in user
      redirect_to user_url(user)
    else
      # Create an error message (Not quite right as flash persists)
      flash.now[:danger] = "Invalid email/password combination"
      render 'new', status: :unprocessable_entity
    end
  end
end
