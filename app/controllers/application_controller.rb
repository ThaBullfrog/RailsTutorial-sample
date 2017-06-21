class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  include SessionsHelper

  protected

    def logged_in_user
      unless logged_in?
        flash[:warning] = "Please log in."
        store_location
        redirect_to login_url
      end
    end

end
