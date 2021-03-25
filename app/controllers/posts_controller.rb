class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :non_presence_post, except: [:new, :create, :index, :rank]

  def new
    @post = Post.new
    @post.photos.build
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path
      flash[:notice] = "投稿が保存されました。"
    else
      render 'new'
    end
  end

  def index
    @search = Post.ransack(params[:q])
    @posts = @search.result.page(params[:page]).reverse_order.per(12)
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new
    @user = @post.user
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
      @post.destroy
      flash[:notice] = "投稿が削除されました。"
    else
      flash[:alert] = "投稿の削除に失敗しました。"
    end
    redirect_to posts_path
  end

  def rank
    posts = Post.includes(:liked_users).sort { |a, b| b.liked_users.size <=> a.liked_users.size }
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(12)
  end

  private

  def post_params
    params.require(:post).permit(:title, :caption, photos_images: []).merge(user_id: current_user.id)
  end

  def non_presence_post
    @post = Post.find_by(id: params[:id])
    if @post.blank?
      redirect_to user_path(current_user), alert: "不正なアクセスです。"
    end
  end
end
