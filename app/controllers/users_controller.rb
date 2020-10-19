# frozen_string_literal: true

class UsersController < ApplicationController
  include Pagy::Backend

  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def index
    @pagy, @users = pagy(User.all, items: 2)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the Oksana`s blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user)
      flash[:success] = 'Your account was updated successfully'
      redirect_to articles_path
    end
  end

  def show
    @user_articles = @user.articles
  end

  def destroy
   @user.destroy
    flash[:danger] = "User and all User's articles have been deleted"
    redirect_to users_path
  end
  
  def set_user
		@user = User.find(params[:id])
	end
  private
  

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
		if current_user != @user
			flash[:danger] = "You can only edit your own account"
			redirect_to root_path
		end
	end
end
