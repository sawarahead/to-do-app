class EventsController < ApplicationController

  require "date"

  before_action :authenticate_user
  before_action :ensure_correct_user,{only:[:show,:edit,:destroy,:update]}

  def ensure_correct_user
    @event=Event.find_by(id:params[:id])
    if @event.user_id!=@current_user.id
      redirect_to("/")
    end
  end

  def new
    @today=Date.today
    @event=Event.new
  end

  def create
    @event=Event.new(
      content:params[:content],
      place:params[:place],
      place_detail:params[:place_detail],
      date:params[:date],
      start_time:params[:start_time],
      end_time:params[:end_time],
      detail:params[:detail],
      repeat:params[:repeat],
      user_id:@current_user.id
    )
    if @event.save
      redirect_to("/home/index")
    else
      render("events/new")
    end
  end

  def destroy   #物理削除
    @event=Event.find_by(id:params[:id])
    @event.destroy
    redirect_to("/home/index")
  end

  def show
    @event=Event.find_by(id:params[:id])
    @week=["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
    @place=["未定","自宅"]
  end

  def edit
    @event=Event.find_by(id:params[:id])
    @repeat_day=["毎週日曜日","毎週月曜日","毎週火曜日","毎週水曜日","毎週木曜日","毎週金曜日","毎週土曜日","毎日","なし"]
    @place=["未定","自宅"]
  end

  def update
    @event=Event.find_by(id:params[:id])

    #イベント会場・繰り返し機能に関して変更しない場合
    if params[:repeat]=="9" && params[:place]=="4"
      @event.content=params[:content]
      @event.date=params[:date]
      @event.start_time=params[:start_time]
      @event.end_time=params[:end_time]
      @event.detail=params[:detail]
      if @event.save
       redirect_to("/events/#{params[:id]}")
      else
       render("events/edit")
      end

    #イベント会場に関してのみ変更がある場合
    elsif params[:repeat]=="9" && params[:place]!="4"
      @event.content=params[:content]
      @event.place=params[:place]
      @event.place_detail=params[:place_detail]
      @event.date=params[:date]
      @event.start_time=params[:start_time]
      @event.end_time=params[:end_time]
      @event.detail=params[:detail]
      if @event.save
       redirect_to("/events/#{params[:id]}")
      else
       render("events/edit")
      end

    #繰り返し機能に関してのみ変更がある場合
    elsif params[:repeat]!="9" && params[:place]=="4"
      @event.content=params[:content]
      @event.date=params[:date]
      @event.start_time=params[:start_time]
      @event.end_time=params[:end_time]
      @event.detail=params[:detail]
      @event.repeat=params[:repeat]
      if @event.save
        redirect_to("/events/#{params[:id]}")
      else
       render("events/edit")
      end

    #全てに変更がある場合
　　 else
      @event.content=params[:content]
      @event.place=params[:place]
      @event.place_detail=params[:place_detail]
      @event.date=params[:date]
      @event.start_time=params[:start_time]
      @event.end_time=params[:end_time]
      @event.detail=params[:detail]
      @event.repeat=params[:repeat]
      if @event.save
       redirect_to("/events/#{params[:id]}")
      else
       render("events/edit")
      end
    end
  end


end
