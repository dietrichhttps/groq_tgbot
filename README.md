# ChatGPT Telegram Bot

Telegram bot that integrates with ChatGPT to generate text responses based on user requests.

## Features

- `/start` and `/help` commands
- ChatGPT API integration
- Dialog history management
- Context awareness using previous messages for better responses
- "New request" button to reset context
- Error handling and exception management

## Requirements

- Python 3.8+
- Telegram Bot Token (get from BotFather)
- OpenAI API Key (get from https://platform.openai.com/api-keys)

## Installation

1. **Clone the repository:**
```bash
git clone <repository_url>
cd chatgpt_tgbot
```

2. **Install dependencies:**
```bash
pip install -r requirements.txt
```

3. **Create `.env` file:**
```bash
cp .env.example .env
```

4. **Edit `.env` and add your API keys:**
```
TELEGRAM_BOT_TOKEN=your_token_here
OPENAI_API_KEY=your_key_here
```

## Running the Bot

```bash
python bot.py
```

## Bot Commands

- `/start` - Start a new dialog (clears message history)
- `/help` - Get usage instructions
- `/history` - Show current dialog history
- "New request" - Button to reset dialog context

## How It Works

1. User sends a message to the bot
2. Bot saves the message in dialog history
3. History is sent to ChatGPT API
4. ChatGPT response is sent back to the user
5. Response is saved in history for context

## Project Structure

```
chatgpt_tgbot/
├── bot.py                # Main bot entry point
├── config.py             # Configuration management
├── chatgpt_client.py     # ChatGPT API client
├── dialogue_manager.py   # Dialog history management
├── utils.py              # Utility functions
├── test_bot.py           # Unit tests
├── requirements.txt      # Python dependencies
├── .env.example          # Environment variables template
├── docker-compose.yml    # Docker compose configuration
└── README.md             # This file
```

## Error Handling

The bot handles the following error types:
- OpenAI authentication errors
- Rate limit exceeded errors
- Network connectivity errors
