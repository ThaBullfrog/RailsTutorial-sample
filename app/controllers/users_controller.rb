class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :user_is_admin, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if(@user.save)
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if(@user.authenticate(params[:user][:password]))
      if(@user.update_attributes(user_update_params))
        flash[:success] = "Successfully updated your account."
        redirect_to @user
      else
        render 'edit'
      end
    else
      flash.now[:danger] = "Incorrect password."
      render 'edit'
    end
  end

  def edit_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    if(@user.authenticate(params[:user][:current_password]))
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if(@user.save)
        flash[:success] = "Password updated successfully."
        redirect_to edit_user_path(@user)
      else
        render 'edit_password'
      end
    else
      flash.now[:danger] = "Current password incorrect."
      render 'edit_password'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      return params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def user_update_params
      update_params = params.require(:user).permit(:name, :email)
      update_params[:password] = params[:user][:password]
      update_params[:password_confirmation] = params[:user][:password]
      update_params
    end

    def logged_in_user
      unless logged_in?
        flash[:warning] = "Please log in."
        store_location
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        deny_access
      end
    end

    def user_is_admin
      unless current_user.admin?
        deny_access
      end
    end

    def deny_access
      flash[:danger] = "Access denied"
      redirect_to(root_url)
    end

end
