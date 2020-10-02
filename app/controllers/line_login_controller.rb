class LineLoginController < ApplicationController

  require "uri"
  require "net/http"
  require "jwt"

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

    @response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    JWT.decode(JSON.parse(@response.body)["id_token"],"606b3608ff10c18bc0c1d92a575d355c")

    uri=URI.parse("https://api.line.me/v2/profile")
    request=Net::HTTP::Get.new(uri)
    request["Authorization"]="Bearer {access token}"
    req_options = {
      use_ssl: uri.scheme == "https"
    }
    response=Net::HTTP::start(uri.hostname, uri.port ,req_options) do |http|
      http.request(request)
    end



  end

  def line_login




  end
end
