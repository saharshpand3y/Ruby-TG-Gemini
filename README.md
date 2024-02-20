# Google's Gemini Integration in Telegram

The Telegram Gemini Project is a Ruby application designed to interact with users via text messages or visualize images based on user queries. It utilizes the Telegram Bot API for communication and integrates with the Gemini API for generating content.

## Description

This project enables users to interact with a Telegram bot by sending text messages or images. The bot processes the user input, performs queries using the Gemini API, and returns relevant responses or visualizations. It leverages natural language processing (NLP) and image recognition technologies to understand user queries and provide accurate outputs.

## Features

- **Text Interaction**: Users can communicate with the bot by sending text messages.
- **Image Visualization**: Users can send images to the bot, which will be processed to generate visualizations based on the content.
- **Natural Language Processing**: The bot utilizes NLP techniques to understand user queries and provide meaningful responses.
- **Image Recognition**: Images sent to the bot are analyzed using image recognition algorithms to extract relevant information.

## Configuration

1. Bot Token:

   - Obtain a Telegram Bot token by creating a bot using the BotFather bot on Telegram.

2. API Key:

   - Obtain a Gemini API Key by Signing up for an account on Gemini's Website.

## Installation

1. Clone the repository:

   ```bash
   $ git clone https://github.com/your-username/telegram-gemini-project.git
   ```

2. Go to Project Directory:

   ```bash
     cd Ruby-TG-Gemini
   ```

3. Rename the .env.sample file to .env & fill in Your Gemini API Key & Telegram Bot Token:

   - [Gemini API](https://aistudio.google.com/app/u/1/apikey)
   - [Telegram Bot Token](http://t.me/botfather)

4. Install dependencies:

   - If you are a Mac/Linux User:

     ```bash
       bash install.sh
     ```

   - If you are using Windows:

     ```bash
       gem install bundler
     ```

     ```bash
       bundle install
     ```

## Usage

1. Run Main

   ```bash
     ruby main.rb
   ```

2. If you want to keep the code always on (Optional):

   ```bash
     sudo apt install screen -y
   ```

   ```bash
     screen -S Bot
   ```

   ```bash
     ruby main.rb
   ```

   - To exit Virtual Screen, Press Ctrl+A+D

3. Interact with your Bot on Telegram:

   - Send text messages to bot to query Information.
   - Send Images to bot with query regarding the image as caption.

## Contributing

- Contributions to the Project are welcome! Feel free to submit pull requests.
