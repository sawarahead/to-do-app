class LineLoginController < ApplicationController

  require "uri"
  require "net/http"
  require "jwt"

  before_action :forbid_user

  def auth_top
    uri=URI.parse("https://api.line.me/oauth2/v2.1/token")
    request=Net::HTTP::Post.new(uri)
    request.content_type="application/x-www-form-urlencoded"
    request.set_form_data(
      "grant_type" => "authorization_code",
      "code" => params[:code],
      "redirect_uri" => "https://infinite-fjord-36648.herokuapp.com/auth",
      "client_id" => ENV["LINElogin_CHANNEL_TOKEN"],
      "client_secret" => ENV["LINElogin_CHANNEL_SECRET"]
    )

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    @response=JWT.decode(JSON.parse(response.body)["id_token"],ENV['LINElogin_CHANNEL_SECRET'])

    @user=User.find_by(name:@response[0]["name"])
  end

  def line_signup
   @user=User.find_by(name:params[:name],password:params[:password])

   if @user
     flash[:notice]="既に登録済みのユーザーです。"
     render("line_login/auth_top")
   else
     @user_new=User.new(name:params[:name],password:params[:password],picture:params[:picture])
     if @user_new.save
       session[:user_id]=@user_new.id
       redirect_to("/home/index")
     else
       redirect_to("/")
     end
   end
  end
end
