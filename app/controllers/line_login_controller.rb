class LineLoginController < ApplicationController

  require "uri"
  require "net/http"

  def line_login
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

    JWT.decode(JSON.parse(response.body)["id_token"],"#{client_secret}")

    @user=User.find_by(name:response.name)

    if @user
      session[:user_id] = @user.id
      redirect_to("/home/index")
    else
      @user_new=User.new(name:response.name)
      @user_new.save
      @user_session=User.find_by(name:response.name)
      session[:user_id] = @user_session.id
      redirect_to("/home/index")
    end
  end
end