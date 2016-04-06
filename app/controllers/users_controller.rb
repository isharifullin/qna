class UsersController < ApplicationController
  authorize_resource
  
  def show
    respond_with @user = User.find(params[:id])
  end
end
