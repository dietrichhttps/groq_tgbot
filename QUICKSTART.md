# Быстрый старт ChatGPT Telegram Bot

## Запуск за 3 шага

### Шаг 1: Получите токены

**Telegram Bot Token:**
1. Найдите в Telegram @BotFather
2. Отправьте `/newbot`
3. Следуйте инструкциям и скопируйте токен

**OpenAI API Key:**
1. Зайдите на https://platform.openai.com/api-keys
2. Нажмите "Create new secret key"
3. Скопируйте ключ

### Шаг 2: Настройка

```bash
# Установите зависимости
pip install -r requirements.txt

# Создайте .env файл
cp .env.example .env

# Отредактируйте .env
nano .env
```

Заполните `.env` вашими токенами:
```
TELEGRAM_BOT_TOKEN=ваш_токен_от_BotFather
OPENAI_API_KEY=ваш_ключ_от_OpenAI
```

### Шаг 3: Запуск

```bash
python bot.py
```

Бот запущен! Откройте Telegram, найдите вашего бота и отправьте `/start`

## Использование

1. **Начните диалог:** `/start`
2. **Задайте вопрос:** просто напишите текстовое сообщение
3. **Сбросьте контекст:** нажмите кнопку "Новый запрос"

Все готово! Бот будет помнить контекст диалога для качественных ответов.