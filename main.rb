require 'telegram/bot'
require 'dotenv/load'
require 'rest-client'
require 'json'
require 'mini_magick'
require 'base64'

def gemini_response(message, api_key)
  if message.text.nil? || message.text.empty?
    response_text = "Please provide some text."
  else
    begin
      url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=#{api_key}"
      payload = {
        contents: [{
          parts: [{
            text: message.text
          }]
        }]
      }
      headers = {
        'Content-Type': 'application/json',
        'Content-Length': payload.to_json.length
      }
      response = RestClient.post(url, payload.to_json, headers)
      response_body = JSON.parse(response.body)
      response_text = response_body['candidates'][0]['content']['parts'][0]['text']
    rescue RestClient::ExceptionWithResponse => e
      puts "Error: #{e.response}"
      response_text = "An error occurred while processing your request."
    rescue StandardError => e
      puts "Error: #{e.message}"
      response_text = "An unexpected error occurred."
    end
  end
  response_text
end

def resize_image(input_path, output_path)
  image = MiniMagick::Image.open(input_path)
  image.resize "512x#{(image.height.to_f * 512 / image.width).to_i}"
  image.write(output_path)
end

def encode_base64(file_path)
  return Base64.strict_encode64(File.read(file_path))
end

def handle_message(bot, message, api_key)
  case message.text
  when '/start'
    bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!\nAsk me Anything & get Started.")
  when '/stop'
    bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
  else
    response_text = gemini_response(message, api_key)
    bot.api.send_message(chat_id: message.chat.id, text: response_text)
  end
end

def handle_photo(bot, message, api_key)
  if message.caption
    caption = message.caption
  else
    caption = "What is this picture?"
  end
  begin
    photo = message.photo.last
    file_path_info = bot.api.get_file(file_id: photo.file_id)
    if file_path_info && file_path_info.file_path
      file_path = file_path_info.file_path
      file_url = "https://api.telegram.org/file/bot#{ENV['BOT_TOKEN']}/#{file_path}"
      file_name = "photo_#{message.from.id}_#{photo.file_id}.jpg"

      File.open(file_name, 'wb') do |file|
        file.write(RestClient.get(file_url))
      end

      output_file = "resized_#{file_name}"
      resize_image(file_name, output_file)

      photo_base64 = encode_base64(output_file)

      payload = {
        "contents":[
          {
            "parts":[
              {"text": caption},
              {
                "inline_data": {
                  "mime_type":"image/jpeg",
                  "data": photo_base64
                }
              }
            ]
          }
        ]
      }
      headers = {
          'Content-Type': 'application/json',
          'Content-Length': payload.to_json.length
        }

      url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=#{api_key}"
      response = RestClient.post(url, payload.to_json, headers)
      response_data = JSON.parse(response.body)
      response_text = response_data['candidates'][0]['content']['parts'][0]['text']
    else
      response_text = "Failed to fetch file information."
    end
  rescue StandardError => e
    puts "Error: #{e.message}"
    response_text = "An unexpected error occurred."
  ensure
    bot.api.send_message(chat_id: message.chat.id, text: response_text)
    File.delete(file_name) if file_name && File.exist?(file_name)
    File.delete(output_file) if output_file && File.exist?(output_file)
  end
end

def main()
  token = ENV['BOT_TOKEN']
  api_key = ENV['API_KEY']
  puts "Starting bot..."
  Telegram::Bot::Client.run(token) do |bot|
    puts "Bot is listening..."
    bot.listen do |message|
      if message.photo
        handle_photo(bot, message, api_key)
      else
        handle_message(bot, message, api_key)
      end
    end
  end
end

if __FILE__ == $0
  main()
end
