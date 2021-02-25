class SessionsController < ApplicationController
  def new
    @site_user = SiteUser.new
  end

  def create
    # do we really care about brute force attacks? add a sleep here?
    site_user_params = params.require(:site_user)

    @site_user = SiteUser.new
      .tap { |su| su.email = site_user_params[:email] }
      .tap { |su| su.password = site_user_params[:password] }

    if @site_user.login_valid?
      session[:current_user] = true
      redirect_to '/admin'
    else
      @site_user.password = nil
      flash[:notice] = 'User does not exist or wrong credentials'
      render 'new'
    end
  end
  
  def logout
    reset_session
    redirect_to root_path
  end
end
