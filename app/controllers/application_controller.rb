class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search_params

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def set_search_params
    @search = Post.ransack(params[:q])
    @posts = @search.result.order('created_at DESC')
  end
end
