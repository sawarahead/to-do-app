class HomeController < ApplicationController

require "date"

  before_action :authenticate_user,{only:[:index]}


  def top

  end

  def index
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
    @today=Date.today
    @datetime=DateTime.now
    @tasks=Task.where(user_id: @current_user.id)
    @count=Task.where("date < ?",@today).where(user_id: @current_user.id).count
    @events=Event.where(user_id: @current_user.id).order(:start_time)
    @repeat=["日","月","火","水","木","金","土","毎","単"]
    @total_task_time=Task.where("date=?",@today).where(user_id: @current_user.id).sum(:time)
    @place=["未定","自宅"]
  end

  def signup
  end

  def normal
  end

  def normal_signup
   @user=User.find_by(name:params[:name],password:params[:password])

   if @user
     flash[:notice]="既に登録済みのユーザーです。"
     render("home/normal")
   else
     @user_new=User.new(name:params[:name],password:params[:password])
     if @user_new.save
       session[:user_id]=@user_new.id
       redirect_to("/home/index")
     else
       redirect_to("/")
     end
   end
  end

  def login
  end

  def login_check
    @user=User.find_by(name:params[:name])

    if @user && @user.authenticate(params[:password])
      session[:user_id]=@user.id
      redirect_to("/home/index")
    else
      flash[:notice]="該当するユーザーが見つかりません。"
      render("home/login")
    end
  end

end
