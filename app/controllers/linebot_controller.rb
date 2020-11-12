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
    tasks = Task.where(date:Date.today).pluck(:content)

    events.each { |event|
      if event.message['text'].include?("1")
        response="本日のto-do-listは#{tasks.count}件です。\nto-doの追加等はwebサイトで行ってください。↓\n https://infinite-fjord-36648.herokuapp.com/ \n（PC専用,chrome推奨）"

      elsif event.message['text'].include?("2")
        if tasks
          response="本日のto-do-listです。\n#{tasks}"
        else
          response="本日のto-do-listが設定されていません。"
        end
      else
        user=User.find_by(name:event.message['text'])
        if user
            response="#{event[1]}"
        else
          response="いないね"
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
