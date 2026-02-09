import os
import logging
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


class Config:
    """Configuration class for the bot"""
    
    # Telegram
    TELEGRAM_BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN')
    
    # OpenAI
    OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
    OPENAI_MODEL = os.getenv('OPENAI_MODEL', 'gpt-3.5-turbo')
    
    # Logging
    LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
    LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    
    @staticmethod
    def validate():
        """Validate that all required environment variables are set"""
        if not Config.TELEGRAM_BOT_TOKEN:
            raise ValueError("TELEGRAM_BOT_TOKEN is not set in environment variables")
        if not Config.OPENAI_API_KEY:
            raise ValueError("OPENAI_API_KEY is not set in environment variables")


def setup_logging():
    """Setup logging configuration"""
    logging.basicConfig(
        format=Config.LOG_FORMAT,
        level=getattr(logging, Config.LOG_LEVEL)
    )
    return logging.getLogger(__name__)
