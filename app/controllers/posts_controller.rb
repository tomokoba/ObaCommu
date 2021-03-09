class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index]

  def new
    @post = Post.new
    @post.photos.build
  end

  def create
    @post = Post.new(post_params)
    if @post.photos.present?
      @post.save
      redirect_to posts_path
      flash[:notice] = "投稿が保存されました"
    else
      redirect_to root_path
      # 後ほどnew_post_pathに変更する
      flash[:alert] = "投稿に失敗しました"
    end
  end

  def index
    @posts = Post.all.includes(:photos, :user).order('created_at DESC')
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def post_params
      params.require(:post).permit(:title, :caption, photos_attributes: [:image]).merge(user_id: current_user.id)
    end

end
