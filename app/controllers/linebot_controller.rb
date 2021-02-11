class LinebotController < ApplicationController

    require "line/bot"
    require "date"

    protect_from_forgery except: :sort

    def client
        @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
    end

    def callback
        body = request.body.read

        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
            error 400 do 'Bad Request' end
        end

        events = client.parse_events_from(body)
        #登録中のタスク・イベントの中で今日の日付のものを取得
        tasks = Task.getTodayUnfinishedTasks(Date.today)
        #Task.where(date:Date.today).where(check:0)
        plans= Event.where(date:Date.today)

        events.each { |event|
            if event.message['text'].include?("p")
                response="こちらがwebサイトのURLです。↓\n https://infinite-fjord-36648.herokuapp.com/ \n※PC専用です（chromeを利用することを推奨します）"

            elsif event.message['text'].include?("使い方")
                response="※このチャットの使い方※
                \n①アプリのwebサイトでLINEアカウントを利用してユーザー登録を行ってください。
                \n②webサイト上で日々のto-doやeventを登録してください。
                \n③このチャットでLINEの登録名を入力してください。
                \n④今日予定しているto-doとeventの一覧をお伝えします。
                \n※詳細な情報が必要な場合はwebサイトで確認してください。
                \nサイトURL:\n https://infinite-fjord-36648.herokuapp.com/ "

            else
                user=User.find_by(name:event.message['text'])
                if user
                    if user.authenticate(event['source']['userId'])
                        user_tasks=tasks.where(user_id:user.id).pluck(:content)
                        task_list=""
                        user_tasks.each do |user_task|
                            task_list += "・#{user_task}\n"
                        end
                        response="本日のto-do:\n#{task_list}\n本日のevent:\n#{plans.where(user_id:user.id).pluck(:content)}"
                    else
                        response="該当するユーザー名は存在しますが、データにアクセスする権限がありません。"
                    end
                else
                    response="「使い方」と入力してください。\nこのチャットの使用方法の一覧を表示します。"
                end
            end

            case event
                when Line::Bot::Event::Message
                    case event.type
                        when Line::Bot::Event::MessageType::Text
                            message = {
                                type: 'text',
                                text: response
                            }
                            client.reply_message(event['replyToken'], message)
                    end
            end
        }
    "OK"
    end
end
