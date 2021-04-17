class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # Used to confirm the session key of the current user
  def index
    @landing = true
    @users = GeneralInfo.order(updated_at: :desc).limit(20)
  end
  # Enables redirect to New User page after sign in
  def after_sign_in_path_for(resource)
    @user = resource
    puts "I'm here!!!!!!!!!!!!!!!!!!!!!!!1"
    puts "User email is  #{@user[:email]}"
    if LoginInfo.exists?(:email => @user[:email])
      puts "I'm here22222!!!!!!!!!!!!!!!!!!!!!!!1"
      super #redirect to where the user came from if not a new user
    else
      puts "I'm here33333333!!!!!!!!!!!!!!!!!!!!!!!1"
      new_general_info_path
    end
  end
end
