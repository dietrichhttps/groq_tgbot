import logging
from typing import List, Dict
import openai
from config import Config

logger = logging.getLogger(__name__)


class ChatGPTClient:
    """Client for interacting with OpenAI ChatGPT API"""
    
    def __init__(self):
        openai.api_key = Config.OPENAI_API_KEY
        self.model = Config.OPENAI_MODEL
    
    async def get_response(self, messages: List[Dict[str, str]]) -> str:
        """
        Get response from ChatGPT based on message history
        
        Args:
            messages: List of message dictionaries with 'role' and 'content'
        
        Returns:
            str: Response from ChatGPT
            
        Raises:
            openai.error.AuthenticationError: If API key is invalid
            openai.error.RateLimitError: If rate limit is exceeded
            Exception: For other API errors
        """
        try:
            logger.info(f"Requesting response from OpenAI with {len(messages)} messages")
            
            response = openai.ChatCompletion.create(
                model=self.model,
                messages=messages,
                max_tokens=2000,
                temperature=0.7
            )
            
            assistant_message = response.choices[0].message.content
            logger.info("Successfully received response from OpenAI")
            return assistant_message
            
        except openai.error.AuthenticationError as e:
            logger.error(f"Authentication error with OpenAI: {str(e)}")
            raise
        
        except openai.error.RateLimitError as e:
            logger.error(f"Rate limit exceeded: {str(e)}")
            raise
        
        except Exception as e:
            logger.error(f"Error calling OpenAI API: {str(e)}")
            raise
