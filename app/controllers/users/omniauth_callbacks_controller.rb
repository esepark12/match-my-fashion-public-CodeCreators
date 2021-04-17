class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # facebook callback
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

    # check if user is in our DB or not
    # if not, add user to our DB
    # Then assign userKey
    if LoginInfo.exists?(:email => @user[:email])
      puts "User exists in our database!!!!!!!!!!!!!!"
      @login_user = LoginInfo.find_by(email: @user[:email])
      userKey = @login_user.userKey
      puts "The user is #{@login_user}"
    else #Else, Add user to the DB
      puts "User doesn't exist in our database!!!!!!!!!!!!"
      #might want to move this to General_info controller b/c the user might not finish
      # entering their information and stop signing up.
      # Or keep it here and let user to edit general_info as they want
      @login_user = LoginInfo.new(:email => @user[:email], :password => @user[:password], :password_confirmation => @user[:password])
      userKey = SecureRandom.hex(10)
      @login_user.userKey = userKey
      puts "Successfully created user in our database!!!!!!"
      if @login_user.save!
        puts "You Have Successfully Signed up! Welcome!"

      end
    end
    session[:current_user_key] = userKey

  end

  # google callback
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      flash[:error] = 'There was a problem signing you in through Google. Please register or try signing in later.'
      redirect_to root_path
    end


    # check if user is in our DB or not
    # if not, add user to our DB
    # Then assign userKey
    if LoginInfo.exists?(:email => @user[:email])
      puts "User exists in our database!!!!!!!!!!!!!!"
      @login_user = LoginInfo.find_by(email: @user[:email])
      userKey = @login_user.userKey
      puts "The user is #{@login_user}"
    else #Else, Add user to the DB
      puts "User doesn't exist in our database!!!!!!!!!!!!"
      #might want to move this to General_info controller b/c the user might not finish
      # entering their information and stop signing up.
      # Or keep it here and let user to edit general_info as they want
      @login_user = LoginInfo.new(:email => @user[:email], :password => @user[:password], :password_confirmation => @user[:password])
      userKey = SecureRandom.hex(10)
      @login_user.userKey = userKey
      puts "Successfully created user in our database!!!!!!"
      if @login_user.save!
        puts "You Have Successfully Signed up! Welcome!"

      end
    end
    session[:current_user_key] = userKey
  end

  def failure
    flash[:error] = 'Problem occured while signing you in. Please try again.'
    redirect_to root_path
  end
end
