class Api::V1::ProfilesController < ApplicationController
  skip_authorization_check
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resoure_owner
  end

  def index
    respond_with User.where.not(id: current_resoure_owner_id)
  end

  protected

  def current_resoure_owner
    @current_resoure_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_resoure_owner_id
   doorkeeper_token.resource_owner_id if doorkeeper_token
  end
end