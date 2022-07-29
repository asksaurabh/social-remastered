class UsersController < ApplicationController
  # Before filter to protect the access to edit page if not logged in
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

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
      # On successful save, ask the use to activate the account
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
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
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE req to delete users by admins
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  private

    # returns only permitted attributes to the user instance for creation.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end

    # Before filters

    # Confirms if the user is logged-in or not
    def logged_in_user
      if logged_in? == false
        store_location   # Capture the current state.(SessionHelper)
        flash[:danger] = "Please log in"
        redirect_to login_url, status: :see_other
      end
    end

    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) if current_user?(@user) == false
    end

    # Confirms an admin user
    def admin_user
      redirect_to(root_url, status: :see_other) if current_user.admin? == false
    end
end
