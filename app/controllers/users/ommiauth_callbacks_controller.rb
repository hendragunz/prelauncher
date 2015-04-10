class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    user = User.find_or_create(request.env['omniauth.auth'])
    sign_in_and_redirect user
  end
end
