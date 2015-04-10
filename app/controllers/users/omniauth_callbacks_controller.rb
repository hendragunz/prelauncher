class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_or_create(request.env['omniauth.auth'])
    sign_in @user

    cookies[:h_email] = @user.email

    # assign refferer if exists
    @referred_by = User.find_by_referral_code(cookies[:h_ref])
    if @referred_by.present?
      @user.referrer = @referred_by
      @user.save
    end

    redirect_to user_refer_path
  end

  protected

  def after_omniauth_failure_path_for(resource_name)
    root_path
  end
end
