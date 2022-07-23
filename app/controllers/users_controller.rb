class UsersController < ApplicationController

  # Action to get the signup page
  def new
    @user = User.new
  end

  # Action to get the profile page of a valid user in DB
  def show
    @user = User.find(params[:id])
  end

  # Action to create a new user from signup page
  def create
    @user = User.new(user_params)
    if(@user.save)
      # On successful save, redirect to user's profile
      redirect_to user_url(@user)
    else
      # Render the signup page(new.html.erb) with error messages
      render 'new', status: :unprocessable_entity
    end
  end

  private

    # returns only permitted attributes to the user instance for creation.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end
end
