class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # Used to confirm the session key of the current user
  def index
    @landing = true
    @users = GeneralInfo.order(updated_at: :desc).limit(20)
  end

  # Enables redirection to New User page after sign in if new user
  # by overriding sign_in_and_redirect in omniauth_callbacks controller
  def after_sign_in_path_for(resource)

    @user = resource
    if LoginInfo.exists?(:email => @user[:email])
      super #redirect to where the user came from if not a new user
    else
      new_general_info_path
    end
  end
end
