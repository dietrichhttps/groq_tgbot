# Quick Start ChatGPT Telegram Bot

## Get a working bot in 5 minutes!

### Step 1: Get tokens (2 minutes)

#### Telegram Bot Token
1. Open Telegram → find **@BotFather**
2. Send `/newbot`
3. Choose a name and username for the bot
4. Copy the **token** (looks like `1234567890:ABCdefGH...`)

#### OpenAI API Key
1. Go to [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Click **"Create new secret key"**
3. Copy the **key** (looks like `sk-XXXXXX...`)

### Step 2: Installation (2 minutes)

```bash
# 1. Clone the project
git clone <repository_url>
cd chatgpt_tgbot

# 2. Install dependencies
pip install -r requirements.txt

# 3. Create .env file
cp .env.example .env

# 4. Edit .env (add your tokens)
nano .env  # or use VS Code, etc.
```

Content of `.env`:
```
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGH...
OPENAI_API_KEY=sk-XXXXXX...
```

### Step 3: Launch (1 minute)

```bash
python bot.py
```

You should see:
```
Starting bot...
Using model: gpt-3.5-turbo
```

### Step 4: Usage (immediately!)

1. Open Telegram
2. Find your bot (by username)
3. Send `/start`
4. **Write your questions** - the bot will answer using ChatGPT!

## Main Commands

| Command | Action |
|---------|--------|
| `/start` | Start a new dialog (clear history) |
| `/help` | Get usage instructions |
| `/history` | Show current dialog history |
| "New request" | Button to reset context |

## Usage Examples

```
You: Hello! How are you?
Bot: Hello! Thank you for asking. I'm a virtual assistant and don't have feelings, 
     but I'm here to help you. How can I assist you?

You: Write a poem about spring
Bot: Here's a poem about spring...

You: What is it called?
Bot: (uses context from previous message) The poem is called...
```

## Docker (alternative)

```bash
# 1. Edit .env
nano .env

# 2. Run Docker
docker-compose up -d

# 3. Check logs
docker-compose logs -f
```

## Troubleshooting

### Error: "ModuleNotFoundError"
```bash
pip install -r requirements.txt
```

### Error: "TELEGRAM_BOT_TOKEN not found"
- Check that the `.env` file exists in the project root
- Make sure both tokens are filled in `.env`

### Bot is not responding
1. Check your internet connection
2. Verify the OpenAI token is correct
3. Check your balance at [platform.openai.com/account/billing](https://platform.openai.com/account/billing)

## Tips

1. **Context history** - The bot remembers recent messages for better answers
2. **Models** - Uses gpt-3.5-turbo (fast), can be changed to gpt-4
3. **Cost** - Check prices at [openai.com/pricing](https://openai.com/pricing)
4. **Security** - Never publish the .env file!

## Done!

Now your bot is working! You can:
- Chat with ChatGPT via Telegram
- Use it 24/7
- Let friends chat (if made public)
- Extend the functionality

## Need help?

- Create an issue on GitHub
- Check the README.md
- Read the comments in bot.py

---

**Good luck with your ChatGPT Telegram Bot!**
