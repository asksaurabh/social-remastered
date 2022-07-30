class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Check if reset link has expired or not (Check - 1)

  def new
  end

  # POST req to Forgot password page
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render "new", status: :unprocessable_entity
    end
  end

  # Reset link renders this page
  def edit
  end

  # PATCH req to update the password
  def update

    # If password entered is empty
    if params[:user][:password].empty?                  
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_entity

    # A successful update 
    elsif @user.update(user_params)   
      @user.forget        # To save hijacked sessions                  
      reset_session
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user

    # Invalid password
    else
      render 'edit', status: :unprocessable_entity      
    end
  end 

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
