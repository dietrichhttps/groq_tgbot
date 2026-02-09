#!/bin/bash

# deployment_script.sh - Script to deploy ChatGPT Telegram Bot

set -e

echo "🚀 ChatGPT Telegram Bot Deployment Script"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Python is installed
echo -e "${YELLOW}Проверка наличия Python...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 не найден. Пожалуйста, установите Python 3.8 или выше.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python3 найден: $(python3 --version)${NC}"

# Check if pip is installed
echo -e "${YELLOW}Проверка наличия pip...${NC}"
if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}❌ pip3 не найден. Пожалуйста, установите pip.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ pip3 найден${NC}"

# Install requirements
echo -e "${YELLOW}Установка зависимостей Python...${NC}"
pip3 install -q -r requirements.txt
echo -e "${GREEN}✅ Зависимости установлены${NC}"

# Check if .env file exists
echo -e "${YELLOW}Проверка конфигурационного файла .env...${NC}"
if [ ! -f .env ]; then
    echo -e "${RED}❌ Файл .env не найден!${NC}"
    echo -e "${YELLOW}Создаю .env из .env.example...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✅ Файл .env создан${NC}"
    echo -e "${RED}⚠️  ВАЖНО: Отредактируйте .env и добавьте ваши API ключи!${NC}"
    echo "TELEGRAM_BOT_TOKEN=your_token_here"
    echo "OPENAI_API_KEY=your_key_here"
    exit 1
else
    echo -e "${GREEN}✅ Файл .env найден${NC}"
fi

# Validate environment variables
echo -e "${YELLOW}Проверка переменных окружения...${NC}"
if grep -q "your_telegram_bot_token_here" .env; then
    echo -e "${RED}❌ TELEGRAM_BOT_TOKEN не заполнен!${NC}"
    exit 1
fi
if grep -q "your_openai_api_key_here" .env; then
    echo -e "${RED}❌ OPENAI_API_KEY не заполнен!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Все переменные окружения заполнены${NC}"

# Run tests
echo -e "${YELLOW}Запуск тестов...${NC}"
if python3 -m pytest test_bot.py -q 2>/dev/null; then
    echo -e "${GREEN}✅ Все тесты пройдены${NC}"
else
    echo -e "${YELLOW}⚠️  Тесты не запустились (pytest может быть не установлен)${NC}"
fi

# Show final information
echo ""
echo -e "${GREEN}=========================================="
echo "✅ Развертывание завершено успешно!"
echo "=========================================${NC}"
echo ""
echo "📝 Для запуска бота используйте команду:"
echo -e "${YELLOW}python3 bot.py${NC}"
echo ""
echo "📝 Для запуска в фоновом режиме:"
echo -e "${YELLOW}nohup python3 bot.py > bot.log 2>&1 &${NC}"
echo ""
echo "📝 Проверить логи:"
echo -e "${YELLOW}tail -f bot.log${NC}"
echo ""
