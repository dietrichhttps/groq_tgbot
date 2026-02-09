#!/bin/bash

# PythonAnywhere Deployment Script for Groq Telegram Bot

set -e  # Exit on error

echo "🚀 Развертывание Telegram бота на PythonAnywhere..."

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для цветного вывода
log_info() {
    echo -e "${GREEN}ℹ️  $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Проверяем, что мы на PythonAnywhere
if ! grep -q "pythonanywhere" "$HOME/.bashrc" 2>/dev/null && [ -z "$PYTHONANYWHERE_SITE" ]; then
    log_warn "Этот скрипт предназначен для запуска на PythonAnywhere"
    log_warn "Убедитесь, что вы выполняете его в PythonAnywhere Bash консоли"
    read -p "Продолжить? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Отмена развертывания"
        exit 1
    fi
fi

# Получаем имя пользователя PythonAnywhere
PYTHONANYWHERE_USERNAME=$(basename "$HOME")
log_info "Имя пользователя: $PYTHONANYWHERE_USERNAME"

# Проверяем наличие необходимых файлов
if [ ! -f "bot.py" ]; then
    log_error "Файл bot.py не найден!"
    exit 1
fi

if [ ! -f "requirements.txt" ]; then
    log_error "Файл requirements.txt не найден!"
    exit 1
fi

# Создаем директорию для бота если её нет
BOT_DIR="$HOME/groq-tgbot"
if [ -d "$BOT_DIR" ]; then
    log_warn "Директория $BOT_DIR уже существует"
    read -p "Удалить и создать заново? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$BOT_DIR"
        log_info "Директория удалена"
    else
        log_info "Используем существующую директорию"
    fi
fi

mkdir -p "$BOT_DIR"
log_info "Директория проекта: $BOT_DIR"

# Копируем файлы проекта
log_info "Копирование файлов проекта..."
cp bot.py requirements.txt .env.example "$BOT_DIR/"
log_info "Файлы скопированы"

# Переходим в директорию проекта
cd "$BOT_DIR"

# Создаем виртуальное окружение
log_info "Создание виртуального окружения..."
if [ ! -d "venv" ]; then
    python3.10 -m venv venv
    log_info "Виртуальное окружение создано"
else
    log_info "Виртуальное окружение уже существует"
fi

# Активируем виртуальное окружение
log_info "Активация виртуального окружения..."
source venv/bin/activate

# Обновляем pip
log_info "Обновление pip..."
pip install --upgrade pip

# Устанавливаем зависимости
log_info "Установка зависимостей..."
pip install -r requirements.txt
log_info "Зависимости установлены"

# Проверяем наличие .env файла
if [ ! -f ".env" ]; then
    log_warn "Файл .env не найден"
    log_info "Создаю .env из .env.example..."
    cp .env.example .env
    log_warn "⚠️  ВАЖНО: Отредактируйте файл .env и добавьте ваши токены!"
    echo "📍 Путь к файлу: $BOT_DIR/.env"
    echo "📍 Нужные переменные:"
    echo "   - TELEGRAM_BOT_TOKEN (от @BotFather)"
    echo "   - GROQ_API_KEY (от console.groq.com)"
    echo ""
    read -p "Нажмите Enter после редактирования .env файла..."
fi

# Проверяем токены в .env
log_info "Проверка переменных окружения..."
source .env

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ "$TELEGRAM_BOT_TOKEN" = "your_telegram_bot_token_here" ]; then
    log_error "TELEGRAM_BOT_TOKEN не настроен!"
    echo "Отредактируйте файл: $BOT_DIR/.env"
    exit 1
fi

if [ -z "$GROQ_API_KEY" ] || [ "$GROQ_API_KEY" = "your_groq_api_key_here" ]; then
    log_error "GROQ_API_KEY не настроен!"
    echo "Отредактируйте файл: $BOT_DIR/.env"
    exit 1
fi

log_info "✅ Токены настроены"

# Тестовый запуск в консоли
log_info "Тестовый запуск бота (Ctrl+C для остановки)..."
echo "🔍 Если бот запустится успешно, нажмите Ctrl+C"
read -p "Готовы к тестовому запуску? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    # Устанавливаем переменную окружения для PythonAnywhere
    export PYTHONANYWHERE=true
    timeout 10s python3.10 -u bot.py || {
        log_warn "Тестовый запуск завершен (это нормально для Always-On задачи)"
    }
fi

# Создаем скрипт для Always-On задачи
log_info "Создание скрипта для Always-On задачи..."
cat > run_bot.sh << 'EOF'
#!/bin/bash
cd /home/$PYTHONANYWHERE_USERNAME/groq-tgbot
source venv/bin/activate
export PYTHONANYWHERE=true
python3.10 -u bot.py
EOF

chmod +x run_bot.sh
log_info "Скрипт run_bot.sh создан"

# Инструкции по созданию Always-On задачи
echo ""
log_info "🎯 Следующие шаги для развертывания:"
echo ""
echo "1. Откройте PythonAnywhere Dashboard"
echo "2. Перейдите в раздел 'Tasks'"
echo "3. Прокрутите вниз до 'Always-on tasks'"
echo "4. Нажмите 'Add an always-on task'"
echo ""
echo "📋 Настройки Always-On задачи:"
echo "   Command: /home/$PYTHONANYWHERE_USERNAME/groq-tgbot/run_bot.sh"
echo "   Description: Groq Telegram Bot"
echo "   Minute: */1 (проверка каждую минуту)"
echo ""
echo "5. Нажмите 'Create'"
echo ""
echo "📊 После создания Always-On задачи:"
echo "   - Проверьте логи в таблице Always-on tasks"
echo "   - Убедитесь что статус 'Running'"
echo "   - Проверьте работу бота в Telegram"
echo ""
echo "🔍 Полезные команды:"
echo "   tail -f /home/$PYTHONANYWHERE_USERNAME/groq-tgbot/run_bot.log"
echo "   cd /home/$PYTHONANYWHERE_USERNAME/groq-tgbot && source venv/bin/activate && python3.10 -u bot.py"
echo ""
log_info "✅ Развертывание завершено! Бот готов к настройке Always-On задачи."