class TasksController < ApplicationController

require "date"


  def weekly
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日","日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
    @today=Date.today
    @tasks=Task.all
    @events=Event.all.order(:start_time)
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
      limit:params[:limit]
    )
    if @task.save
      redirect_to("/tasks/index")
    else
      render("tasks/new")
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
        @task.destroy
      else
        @task_copy.date = @today + 7
        @task_copy.save
        @task.destroy
      end
    else
      @task.destroy
    end
    flash[:notice]="いい感じ！"
    redirect_to("/tasks/index")
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
    @tasks=Task.all
    @events=Event.all
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
    @task.save
    redirect_to("/tasks/#{params[:id]}")
  end

  def unfinished
    @today=Date.today
    @datetime=DateTime.now
    @unfinished_tasks=Task.where("date < ?",@today)
    @unfinished_tasks_count=Task.where("date < ?",@today).count
  end

  def add
    @today=Date.today
    @task=Task.find_by(id:params[:id])
    @task.date=@today
    @task.save
    redirect_to("/tasks/unfinished")
  end
end
