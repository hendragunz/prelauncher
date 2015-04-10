class Users::SessionsController < Devise::SessionsController
  def new
    redirect_to root_path
  end

  def destroy
    cookies.delete :h_email
    super
  end
end