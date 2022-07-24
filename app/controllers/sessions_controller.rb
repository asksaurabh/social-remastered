class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    
    # If user exists and it's password matches
    # !! -> returns the value in boolean context
    if !!(user && user.authenticate(params[:session][:email]))
      # Redirect to profile page of the user
    else
      # Create an error message
      render 'new', status: :unprocessable_entity
    end
  end
end
