class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_omniauth
  
  def facebook
  end

  def twitter
  end

  def finish_sign_up
  end

  private 

  def sign_in_omniauth
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    elsif !auth.empty?
        flash[:notice] = 'To complete the sign up enter email.'
        render 'omniauth_callbacks/finish_sign_up', locals: { auth: auth }
    end
  end

   def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
   end
end