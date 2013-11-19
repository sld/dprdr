class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end


  def dropbox
    @user = User.find_for_dropbox_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      if @user.just_created
        redirect_to dropbox_folder_select_url
      else
        redirect_to books_path
      end
      set_flash_message(:notice, :success, :kind => "Dropbox") if is_navigational_format?
    else
      session["devise.dropbox_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end