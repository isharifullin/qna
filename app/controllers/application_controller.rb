class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :init_gon_current_user

  private
  def init_gon_current_user
    if user_signed_in?
      gon.current_user_id = current_user.id
    else 
      gon.current_user_id = nil
    end
  end
end
