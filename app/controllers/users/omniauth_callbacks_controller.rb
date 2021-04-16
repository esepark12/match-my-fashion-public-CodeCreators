class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?#LoginInfo.exists?(:email => @user[:email]) #is user in our database?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      puts "Facebook: User exists so login"


    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      puts "Facebook: WHAT IS THIS!!!!!!!!"

      redirect_to root_path #change to new_general_info_path for creating user profile
    end
    puts "Hello do I get here???"

    #check if user is in our database or not

    userKey = SecureRandom.hex(10)
    session[:current_user_key] = userKey
  end

  def failure
    redirect_to root_path
  end
end
