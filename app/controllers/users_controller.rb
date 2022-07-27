class UsersController < ApplicationController

  # GET request to show sign-up page
  def new
    @user = User.new
  end

  # GET request to show user profile
  def show
    @user = User.find(params[:id])
  end

  # POST request to create a new user.
  def create
    @user = User.new(user_params)
    if(@user.save)
      # On successful save, log in the user and redirect to user's profile
      reset_session         # Guard against session-fixation attacks
      log_in @user
      flash[:success] = "Welcome to the Socials!"
      redirect_to @user
    else
      # Render the signup page(new.html.erb) with error messages
      render 'new', status: :unprocessable_entity
    end
  end

  # GET request to edit details.
  def edit
    @user = User.find(params[:id])
  end

  # PATCH request to edit details.
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # Handle a successful update.
      flash[:messages] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    # returns only permitted attributes to the user instance for creation.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end
end
