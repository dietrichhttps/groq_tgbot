# Развертывание ChatGPT Telegram Bot

Этот документ содержит инструкции по развертыванию бота на различных платформах.

## Содержание

1. [Локальное развертывание](#локальное-развертывание)
2. [Linux сервер](#linux-сервер)
3. [Windows сервер](#windows-сервер)
4. [Docker](#docker)
5. [Облачные сервисы](#облачные-сервисы)

## Локальное развертывание

### Требования

- Python 3.8+
- pip
- Telegram Bot Token
- OpenAI API Key

### Шаги

1. Клонируйте репозиторий:
```bash
git clone <repository_url>
cd chatgpt_tgbot
```

2. Используйте скрипт deploy.sh (рекомендуется):
```bash
chmod +x deploy.sh
./deploy.sh
```

Или вручную:
```bash
pip install -r requirements.txt
cp .env.example .env
# Отредактируйте .env с вашими ключами
nano .env
```

3. Запустите бота:
```bash
python bot.py
```

## Linux сервер

### Вариант 1: Запуск в фоновом режиме с nohup

```bash
# Запуск в фоновом режиме
nohup python3 bot.py > bot.log 2>&1 &

# Проверка логов
tail -f bot.log

# Остановка бота
pkill -f "python3 bot.py"
```

### Вариант 2: Systemd сервис

1. Создайте файл сервиса:
```bash
sudo nano /etc/systemd/system/chatgpt-bot.service
```

2. Добавьте следующее содержимое:
```ini
[Unit]
Description=ChatGPT Telegram Bot
After=network.target

[Service]
Type=simple
User=your_username
WorkingDirectory=/path/to/chatgpt_tgbot
Environment="PATH=/path/to/venv/bin"
ExecStart=/path/to/venv/bin/python bot.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

3. Активируйте сервис:
```bash
sudo systemctl daemon-reload
sudo systemctl enable chatgpt-bot
sudo systemctl start chatgpt-bot
```

4. Проверьте статус:
```bash
sudo systemctl status chatgpt-bot
```

5. Просмотрите логи:
```bash
sudo journalctl -u chatgpt-bot -f
```

### Вариант 3: Screen

```bash
# Запуск в screen
screen -S chatgpt-bot
python3 bot.py

# Отделиться от screen: Ctrl+A затем D

# Вернуться к screen
screen -r chatgpt-bot

# Завершить screen
exit
```

### Вариант 4: Tmux

```bash
# Запуск в tmux
tmux new-session -d -s chatgpt-bot

# Запуск бота в сессии
tmux send-keys -t chatgpt-bot "cd /path/to/chatgpt_tgbot && python3 bot.py" Enter

# Просмотр сессии
tmux attach -t chatgpt-bot

# Завершить сессию
tmux kill-session -t chatgpt-bot
```

## Windows сервер

### Вариант 1: Прямой запуск

```cmd
cd path\to\chatgpt_tgbot
python bot.py
```

### Вариант 2: Запуск в фоновом режиме (cmd)

```cmd
start /B python bot.py
```

### Вариант 3: Windows Task Scheduler

1. Откройте Task Scheduler
2. Создайте новую задачу
3. Установите расписание (например, при загрузке)
4. В "Action" установите:
   - Program: `C:\path\to\python.exe`
   - Arguments: `bot.py`
   - Start in: `C:\path\to\chatgpt_tgbot`

### Вариант 4: Windows Service (NSSM)

1. Скачайте NSSM с [nssm.cc](https://nssm.cc/)
2. Распакуйте и добавьте в PATH
3. Запустите:
```cmd
nssm install ChatGPTBot "C:\path\to\python.exe" "bot.py"
nssm start ChatGPTBot
```

## Docker

### Создание Dockerfile

```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "bot.py"]
```

### Создание docker-compose.yml

```yaml
version: '3.8'

services:
  chatgpt-bot:
    build: .
    container_name: chatgpt-bot
    environment:
      - TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - OPENAI_MODEL=${OPENAI_MODEL:-gpt-3.5-turbo}
      - LOG_LEVEL=${LOG_LEVEL:-INFO}
    restart: unless-stopped
    volumes:
      - ./logs:/app/logs
    networks:
      - chatgpt-network

networks:
  chatgpt-network:
    driver: bridge
```

### Запуск с Docker

```bash
# Создание .env файла
cp .env.example .env
# Отредактируйте .env

# Запуск контейнера
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Остановка
docker-compose down
```

## Облачные сервисы

### Heroku (больше не поддерживает бесплатный уровень, но код совместим)

Создайте `Procfile`:
```
worker: python bot.py
```

### Railway.app

1. Создайте аккаунт на [railway.app](https://railway.app)
2. Свяжите GitHub репозиторий
3. Добавьте переменные окружения в Railway
4. Деплой произойдет автоматически

### Google Cloud Run

```bash
# Создание Dockerfile (см. выше)

# Развертывание
gcloud run deploy chatgpt-bot \
  --source . \
  --platform managed \
  --region us-central1 \
  --set-env-vars TELEGRAM_BOT_TOKEN=your_token \
  --set-env-vars OPENAI_API_KEY=your_key
```

### AWS Lambda + API Gateway

Требуется изменение кода для использования вебхуков вместо polling.

### DigitalOcean App Platform

1. Создайте аккаунт на [digitalocean.com](https://digitalocean.com)
2. Свяжите GitHub репозиторий
3. Выберите Python как runtime
4. Добавьте переменные окружения
5. Разверните

## Мониторинг

### Логирование

Логи доступны в:
- Linux/Mac: Прямо в консоли или файле при использовании nohup
- Windows: В консоли или через Event Viewer
- Docker: `docker-compose logs -f`

### Проверка здоровья

```bash
# Простой скрипт для проверки
#!/bin/bash
if pgrep -f "python.*bot.py" > /dev/null; then
    echo "Bot is running"
else
    echo "Bot is down - restarting"
    # Команда для перезагрузки
fi
```

## Советы по производительности

1. **Используйте виртуальное окружение:**
```bash
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate  # Windows
pip install -r requirements.txt
```

2. **Ограничьте логирование в продакшене:**
```bash
LOG_LEVEL=WARNING python bot.py
```

3. **Мониторьте использование ресурсов:**
```bash
top -p $(pgrep -f "python.*bot.py")
```

4. **Установите лимиты на количество сообщений:**
- В коде можно добавить rate limiting
- На уровне OpenAI задайте лимиты в аккаунте

## Резервное копирование

История диалогов хранится в памяти и теряется при перезагрузке.

Для персистентного хранения:
1. Добавьте БД (SQLite, PostgreSQL, MongoDB)
2. Сохраняйте историю в БД
3. Восстанавливайте историю при запуске

## Обновление кода

```bash
# Остановить бота
sudo systemctl stop chatgpt-bot

# Получить последние изменения
git pull origin main

# Установить новые зависимости
pip install -r requirements.txt

# Запустить тесты
python -m pytest test_bot.py

# Запустить бота
sudo systemctl start chatgpt-bot
```

## Неполадки

### Бот не отвечает

1. Проверьте токен Telegram
2. Проверьте API ключ OpenAI
3. Проверьте интернет-соединение
4. Проверьте логи

### Rate limiting от Telegram

- Telegram имеет лимиты на количество сообщений
- Добавьте задержки между сообщениями
- Не отправляйте более 30 сообщений в секунду одному пользователю

### Rate limiting от OpenAI

- Проверьте лимиты на вашем аккаунте OpenAI
- Уменьшите количество одновременных запросов
- Добавьте очередь запросов

## Контакт и поддержка

Если у вас возникли проблемы с развертыванием, создайте issue в репозитории.
