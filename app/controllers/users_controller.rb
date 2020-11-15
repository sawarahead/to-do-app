class UsersController < ApplicationController

  #before_action :authenticate_user

  def logout  #セッションの解除
    session[:user_id] = nil
    redirect_to("/")
  end
end
