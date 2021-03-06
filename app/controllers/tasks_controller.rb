class TasksController < ApplicationController

    require "date"

    before_action :authenticate_user
    before_action :ensure_correct_user,{only:[:show,:edit,:update,:destroy,:delete,:add]}

    def ensure_correct_user                                    #データを登録したユーザー以外のユーザーに対して登録データの閲覧を禁止
        @task=Task.find_by(id: params[:id])
        if @task.user_id != @current_user.id
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
        @task.SpecialDestroy(@today)
        redirect_to("/home/index")
    end

    def delete      #「予約を消す」ボタンが押された際に実行
        @task=Task.find_by(id:params[:id])        #即座に登録データを削除する
        @task.destroy
        redirect_to("/home/memory")
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
        @task.AddToday(@today)
        redirect_to("/tasks/unfinished")
    end

    def nextday
      @task=Task.find_by(id:params[:id])
      @task.date=Date.today+1
      @task.save
      redirect_to("/home/index")
    end

end
