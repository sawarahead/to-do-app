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
      "client_id" => "1654987275",
      "client_secret" => "606b3608ff10c18bc0c1d92a575d355c"
    )

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    @response=JWT.decode(JSON.parse(response.body)["id_token"],"606b3608ff10c18bc0c1d92a575d355c")

    @user=User.find_by(name:@response[0]["name"])
  end

  def line_login

   @user=User.find_by(name:@response[0]["name"],picture:@response[0]["picture"])

   if @user
     session[:user_id]=@user.id
     redirect_to("/home/index")
   else
     @user_new=User.new(name:@response[0]["name"],picture:@response[0]["picture"])
     if @user_new.save
       session[:user_id]=@user_new.id
       redirect_to("/home/index")
     else
       redirect_to("/")
     end
   end
  end
end
