class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  protected

  def current_resoure_owner
    @current_resoure_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end


  def current_resoure_owner_id
   doorkeeper_token.resource_owner_id if doorkeeper_token
  end 

  def current_ability
    @ability ||= Ability.new(current_resoure_owner)
  end
end