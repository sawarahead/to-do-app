class TasksController < ApplicationController

require "date"

before_action :authenticate_user
before_action :ensure_correct_user,{only:[:show,:edit,:update,:destroy,:delete,:add]}

  def ensure_correct_user
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
      check:0
    )
    if @task.save
      redirect_to("/home/index")
    else
      render("task/new")
    end
  end

  def destroy
    @task=Task.find_by(id:params[:id])
    @today=Date.today
    if @task.repeat != 8
      @task_copy = @task.dup
      if @task.repeat == 7
        @task_copy.date = @today + 1
        @task_copy.save
        @task.check = 1
        @task.save
      else
        @task_copy.date = @today + 7
        @task_copy.save
        @task.check = 1
        @task.save
      end
    else
      @task.check = 1
      @task.save
    end
    redirect_to("/home/index")
    Task.where("date<?",@today-7).destroy_all
  end

  def delete
    @task=Task.find_by(id:params[:id])
    @task.destroy
    redirect_to("/tasks/memory")
  end

  def show
    @task=Task.find_by(id:params[:id])
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
  end

  def memory
    @tasks=Task.where(user_id: @current_user.id).where(check:0)
    @events=Event.where(user_id: @current_user.id)
    @today=Date.today
    @datetime=DateTime.now
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
  end

  def edit
    @task=Task.find_by(id:params[:id])
    @repeat_day=["毎週日曜日","毎週月曜日","毎週火曜日","毎週水曜日","毎週木曜日","毎週金曜日","毎週土曜日","毎日","なし"]
  end

  def update
    @task=Task.find_by(id:params[:id])
    @task.content=params[:content]
    @task.detail=params[:detail]
    @task.time=params[:planed_time]
    @task.date=params[:date]
    @task.repeat=params[:repeat]
    @task.limit=params[:limit]
    @task.save
    redirect_to("/tasks/#{params[:id]}")
  end

  def unfinished
    @today=Date.today
    @datetime=DateTime.now
    @unfinished_tasks=Task.where("date < ?",@today).where(user_id: @current_user.id).where(check:0)
  end

  def add
    @today=Date.today
    @task=Task.find_by(id:params[:id])
    @task.date=@today
    @task.save
    redirect_to("/tasks/unfinished")
  end
end
