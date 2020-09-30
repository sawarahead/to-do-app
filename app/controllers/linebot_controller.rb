class LinebotController < ApplicationController

  require "line/bot"

  protect_from_forgery except: :sort

  def client
    @client ||= Line::Bot::Client.new { |config|
      # ローカルで動かすだけならベタ打ちでもOK。
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  # ルーティングで設定したcallbackアクションを呼び出す
  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each { |event|
      if event.message['text'].include?("1")
        response="gaggagaga"

      elsif event.message['text'].include?("2")
        response="あははは"
      else
        response="oooooo"
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
