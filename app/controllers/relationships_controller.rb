class RelationshipsController < ApplicationController
  before_action :set_user

  def create
    following = current_user.follow(@user)
    following.save
  end

  def destroy
    following = current_user.following(@user)
    following.destroy
    split_url = request.referer.split("/")
    @following_flg = false;
    if split_url[4] == current_user.id
      #前のページが指定したURLだった場合のリンク先
      @following_flg = true;
    end
  end

  private
  def set_user
    @user = User.find(params[:follow_id])
  end

end
