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
      flash[:notice] = "投稿が保存されました。"
    else
      redirect_to new_post_path
      flash[:alert] = "投稿に失敗しました。"
    end
  end

  def index
    @posts = Post.all.includes(:photos, :user).order('created_at DESC')
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
        redirect_to post_path(@post), alert: "不正なアクセスです。"
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿内容を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.user == current_user
      flash[:notice] = "投稿が削除されました。" if @post.destroy
    else
      flash[:alert] = "投稿の削除に失敗しました。"
    end
    redirect_to posts_path
  end

  private
    def post_params
      params.require(:post).permit(:title, :caption, photos_images:[] ).merge(user_id: current_user.id)
    end

end
