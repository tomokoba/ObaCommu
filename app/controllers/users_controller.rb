class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user || @user == User.guest
      redirect_to user_path(current_user), alert: "不正なアクセスです。"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "会員情報を更新しました。"
    else
      render :edit
    end
  end

  def unsubscribe
    @user = User.find(params[:id])
    if @user == User.guest
      redirect_to user_path(current_user), alert: "不正なアクセスです。"
    end
  end

  def withdraw
    @user = current_user
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  def following
    @user  = User.find(params[:id])
    @followings = @user.followings
  end

  def followers
    @user  = User.find(params[:id])
    @followers = @user.followers
  end
  
  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end
