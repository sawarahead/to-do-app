class HomeController < ApplicationController

require "date"


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

end
