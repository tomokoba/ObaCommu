class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :non_presence_user, except: [:index]

  def index
    @users = User.all.page(params[:page]).reverse_order.per(12)
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
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
    @user = User.find_by(id: params[:id])
    if @user != current_user || @user == User.guest
      redirect_to user_path(current_user), alert: "不正なアクセスです。"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  def following
    @user = User.find_by(id: params[:id])
    @followings = @user.followings
  end

  def followers
    @user = User.find_by(id: params[:id])
    @followers = @user.followers
  end

  def likes
    @user = User.find_by(id: params[:id])
    likes = Like.where(user_id: @user.id)
    @likes = Kaminari.paginate_array(likes).page(params[:page]).per(12)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end

  def non_presence_user
    @user = User.find_by(id: params[:id])
    if @user.blank?
      redirect_to user_path(current_user), alert: "不正なアクセスです。"
    end
  end
end
