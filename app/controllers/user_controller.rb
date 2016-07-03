class UserController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit, :update,:destroy]
  before_action :correct_user, only: [:edit,:update]
  before_action :admin_user,   only: :destroy
  def create
    @user =User.new(user_params)
    if @user.save
      @user.send_activation_email

      flash[:info]= "Please check your email to activate your account"
      redirect_to root_url
    else
      render action: 'new'
    end
  end

  def new
    @user=User.new
  end

  def index
    search
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])

  end

  def edit
    search
    @user = User.find(params[:id])

  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "user deleted"
    redirect_to user_url
  end


  private
  def user_params
    params[:user].permit(:name, :password_digest, :password, :password_confirmation, :email)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in"
      store_location
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])

    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end


end