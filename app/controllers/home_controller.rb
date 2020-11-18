class HomeController < ApplicationController

require "date"


  before_action :authenticate_user,{only:[:index]}


  def top
  end

  def index    #個別のリストの機能はtaskとeventのコントローラーで定義
    #配列
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
    @repeat=["日","月","火","水","木","金","土","毎","単"]
    @place=["未定","自宅"]
    #今日の日付
    @today=Date.today
    @datetime=DateTime.now
    #タスク達成率・to-do-list関連変数
    @user_tasks=Task.where(user_id: @current_user.id)                           #ユーザーが登録したタスク
    @today_all_tasks=@user_tasks.where("date=?",@today)                         #今日表示予定のタスク
    @tasks=@user_tasks.where(check:0)                                           #未完了のタスク
    @unfinish_count=@tasks.where("date < ?",@today).where(unfinish:0).count     #昨日以前で未完了のタスクの数
    @total_task_time=@tasks.where("date=?",@today).sum(:time)                   #今日登録しているタスクの総時間
    #event-list関連変数
    @events=Event.where(user_id: @current_user.id).order(:start_time)           #ユーザーが登録したイベントを開始時間順に取得
  end

  def memory
    @tasks=Task.where(user_id: @current_user.id).where(check:0).where(unfinish:0)
    @events=Event.where(user_id: @current_user.id)
    @today=Date.today
    @datetime=DateTime.now
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
  end

  def signup_branch
  end

  def get_normal_signup
  end

  def post_normal_signup
   @user=User.find_by(name:params[:name])

   if @user && @user.authenticate(params[:password])
     flash[:notice]="既に登録済みのユーザーです。"
     render ("home/get_normal_signup")
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

  def normal_login
  end

  def normal_login_check
    @user=User.find_by(name:params[:name])

    if @user && @user.authenticate(params[:password])
      session[:user_id]=@user.id
      redirect_to("/home/index")
    else
      flash[:notice]="該当するユーザーが見つかりません。"
      render("home/normal_login")
    end
  end

end
