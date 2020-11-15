class TasksController < ApplicationController

require "date"

before_action :authenticate_user
before_action :ensure_correct_user,{only:[:show,:edit,:update,:destroy,:delete,:add]}

  def ensure_correct_user                                    #データを登録したユーザー以外に対して登録データの閲覧を禁止
    @task=Task.find_by(id: params[:id])
    if @task.user_id!=@current_user.id
      redirect_to("/")
    end
  end

  def weekly
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日","日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
    @today=Date.today
    @tasks=Task.where(user_id: @current_user.id).where(check:0)
    @events=Event.where(user_id: @current_user.id).order(:start_time)
  end

  def new
    @today=Date.today
    @task=Task.new
  end

  def create
    @task=Task.new(
      content:params[:content],
      detail:params[:detail],
      time:params[:planed_time],
      date:params[:date],
      repeat:params[:repeat],
      limit:params[:limit],
      user_id:@current_user.id,
      check:"0",
      unfinish:"0"
    )
    if @task.save
      redirect_to("/home/index")
    else
      render("tasks/new")
    end
  end

  def destroy      #基本的には物理削除。「終わった！」ボタンが押された際に実行。
    @task=Task.find_by(id:params[:id])
    @today=Date.today
    if @task.repeat != 8                       #繰り返し機能が設定されている場合は「終わった！」ボタンが押されても即座に削除はしない
      @task_copy = @task.dup                   #データを複製
      if @task.repeat == 7
        @task_copy.date = @today + 1           #複製したデータの実行予定日を、毎日繰り返しなら明日、毎週繰り返しなら来週の日付に変更
        @task_copy.save                        #複製データを保存
        @task.check = 1                        #複製元のデータの「checkカラム」の値を1（完了扱い）に変更
        @task.save                             #複製元データを保存
      else
        @task_copy.date = @today + 7
        @task_copy.save
        @task.check = 1
        @task.save
      end
    else                                       #繰り返し設定がされてない場合はデータの複製は行わず、「checkカラム」を１に変更して保存
      @task.check = 1
      @task.save
    end
    redirect_to("/home/index")
    Task.where("date<?",@today-7).destroy_all   #実行予定日が１週間以上前のデータを削除
  end

  def delete      #「予約を消す」ボタンが押された際に実行
    @task=Task.find_by(id:params[:id])        #即座に登録データを削除する
    @task.destroy
    redirect_to("/tasks/memory")
  end

  def show
    @task=Task.find_by(id:params[:id])
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
  end

  def edit
    @task=Task.find_by(id:params[:id])
    @repeat_day=["毎週日曜日","毎週月曜日","毎週火曜日","毎週水曜日","毎週木曜日","毎週金曜日","毎週土曜日","毎日","なし"]
  end

  def update
    @task=Task.find_by(id:params[:id])
    if params[:repeat]=="9"                            #繰り返し機能に関して変更がない場合
      @task.content=params[:content]
      @task.detail=params[:detail]
      @task.time=params[:planed_time]
      @task.date=params[:date]
      @task.limit=params[:limit]
      @task.save
    else                                               #繰り返し機能に関して変更がある場合
      @task.content=params[:content]
      @task.detail=params[:detail]
      @task.time=params[:planed_time]
      @task.date=params[:date]
      @task.repeat=params[:repeat]
      @task.limit=params[:limit]
      @task.save
    end
    redirect_to("/tasks/#{params[:id]}")
  end

  def unfinished
    @today=Date.today
    @datetime=DateTime.now
    @unfinished_tasks=Task.where("date < ?",@today).where(user_id: @current_user.id).where(check:0).where(unfinish:0)
  end

  def add
    @today=Date.today
    @task=Task.find_by(id:params[:id])
    @task_copy = @task.dup                               #データを複製
    @task_copy.unfinish=1                                #複製したデータの「unfinishカラム」の値を１(未完了扱い)に変更
    @task_copy.save                                      #複製したデータを保存
    @task.date=@today                                    #複製元のデータの実行予定日を今日の日付に変更
    @task.save                                           #複製元データを保存
    redirect_to("/tasks/unfinished")
  end
end
