"""
Examples of using the ChatGPT Telegram Bot

This file demonstrates various usage patterns and features.
"""

# Example 1: User starts the bot
# User sends: /start
# Bot response: Shows welcome message and clears conversation history

# Example 2: User asks a question
# User sends: "Какова столица Франции?"
# Bot processes message through DialogueManager -> ChatGPTClient
# Bot response: "Столица Франции - Париж..."

# Example 3: Multi-turn conversation
# User sends: "Какова столица Франции?"
# Bot response: "Столица Франции - Париж..."
# User sends: "Каково население этого города?"
# Bot uses context from previous message to understand "этого города" = Париж
# Bot response: "Население Парижа составляет..."

# Example 4: Reset conversation
# User clicks button "Новый запрос"
# Bot clears conversation history for this user
# Next message starts fresh conversation

# Example 5: Help command
# User sends: /help
# Bot response: Shows detailed help information about available commands

# Example 6: Error handling
# User sends message but OpenAI API returns error
# Bot catches exception and sends appropriate error message
# Examples:
#   - Authentication error: "❌ Ошибка аутентификации..."
#   - Rate limit: "⏳ Превышено ограничение на количество запросов..."
#   - Other errors: "❌ Произошла ошибка..."

# Example 7: Multiple users
# User 1 (ID: 123456) sends: "Hello"
# User 2 (ID: 789012) sends: "Hi"
# Bot maintains separate conversation histories for each user
# Each user gets their own context and history

# Example 8: Conversation memory
# User sends: "Как дела?"
# Bot response: "Спасибо за вопрос! У меня всё хорошо. А у вас?"
# User sends: "Хорошо! Можешь помочь мне с кодом?"
# Bot response uses memory of previous messages to provide better context
