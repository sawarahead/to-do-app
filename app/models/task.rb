class Task < ApplicationRecord
    validates :content, {presence: true}
    validates :time, {presence: true}
    validates :repeat, {presence: true}
    validates :date, {presence: true}

    def SpecialDestroy(today)
      if self.repeat != 8                       #繰り返し機能が設定されている場合は「終わった！」ボタンが押されても即座に削除はしない
          task_copy = self.dup                   #データを複製
          if self.repeat == 7
              task_copy.date = today + 1           #複製したデータの実行予定日を、毎日繰り返しなら明日、毎週繰り返しなら来週の日付に変更
              task_copy.save                        #複製データを保存
              self.check = 1                        #複製元のデータの「checkカラム」の値を1（完了扱い）に変更
              self.save                             #複製元データを保存
          else
              task_copy.date = today + 7
              task_copy.save
              self.check = 1
              self.save
          end
      else                                       #繰り返し設定がされてない場合はデータの複製は行わず、「checkカラム」を１に変更して保存
          self.check = 1
          self.save
      end
      Task.where("date<?",today-7).destroy_all   #実行予定日が１週間以上前のデータを削除
    end

    

end
