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
    @user = User.new(params[:user])
    if(@user.save)
      # handle successful save
    else
      # Render the signup page(new.html.erb) with error messages
      render 'new', status: :unprocessable_entity
    end
  end
end
