class ApplicationController < ActionController::Base

before_action :set_current_user

def set_current_user                                        #ログイン中のユーザーデータを特定
  @current_user= User.find_by(id: session[:user_id])
end

def authenticate_user                                       #ログイン中のユーザーが存在しない場合トップページに戻す
  if @current_user == nil
    redirect_to("/")
  end
end

def forbid_user                                             #ログイン中のユーザーのアクセスを制限
  if @current_user
    redirect_to("/home/index")
  end
end

end
