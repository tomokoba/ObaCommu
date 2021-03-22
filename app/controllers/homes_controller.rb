class HomesController < ApplicationController

  def top
    @posts = Post.all.order('created_at DESC').limit(3)
  end

end
