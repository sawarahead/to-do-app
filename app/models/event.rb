class Event < ApplicationRecord
    validates :content, presence: {message: "イベント名を入力してください"}
    validates :repeat, presence: true
    validates :date, presence: true
    validates :start_time, presence: true
    validates :place, presence: true

    def EventUpdate(repeat,content,place,place_detail,date,start_time,end_time,detail)
      if repeat=="9" && place=="4"                      #イベント会場・繰り返し機能に関して変更しない場合
          self.content=content
          self.date=date
          self.start_time=start_time
          self.end_time=end_time
          self.detail=detail

      elsif repeat=="9" && place!="4"                   #イベント会場に関してのみ変更がある場合
          self.content=content
          self.place=place
          self.place_detail=place_detail
          self.date=date
          self.start_time=start_time
          self.end_time=end_time
          self.detail=detail

      elsif repeat!="9" && place=="4"                  #繰り返し機能に関してのみ変更がある場合
          self.content=content
          self.date=date
          self.start_time=start_time
          self.end_time=end_time
          self.detail=detail
          self.repeat=repeat

      else                                                               #全てに変更がある場合
          self.content=content
          self.place=place
          self.place_detail=place_detail
          self.date=date
          self.start_time=start_time
          self.end_time=end_time
          self.detail=detail
          self.repeat=repeat

      end
    end

end
