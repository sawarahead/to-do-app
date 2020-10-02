class HomeController < ApplicationController

require "date"
require "uri"
require "net/http"

  def top

  end

  def index
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
    @today=Date.today
    @datetime=DateTime.now
    @tasks=Task.all
    @count=Task.where("date < ?",@today).count
    @events=Event.all.order(:start_time)
    @repeat=["日","月","火","水","木","金","土","毎","単"]
    @total_task_time=Task.where("date=?",@today).sum(:time)
    @place=["未定","自宅"]
  end

  def line_login
    uri=URI.parse("https://api.line.me/oauth2/v2.1/token")
    request=Net::HTTP::Post.new(uri)
    request.content_type="application/x-www-form-urlencoded"
    request.set_form_data(
      "grant_type" => "authorization_code",
      "code" => params[:code],
      "redirect_uri" => "https://infinite-fjord-36648.herokuapp.com/home/index/auth",
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
      redirect_to("/")
    else
      @user_new=User.new(name:response.name)
      @user_new.save
      @user_session=User.find_by(name:response.name)
      session[:user_id] = @user_session.id
      redirect_to("/")
    end
  end

end
