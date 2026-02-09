import logging
from typing import Dict, List

logger = logging.getLogger(__name__)


class DialogueManager:
    """Manages conversation history for each user"""
    
    def __init__(self):
        """Initialize the dialogue manager"""
        self.conversations: Dict[int, List[Dict]] = {}
    
    def add_message(self, user_id: int, role: str, content: str) -> None:
        """
        Add a message to the conversation history
        
        Args:
            user_id: Telegram user ID
            role: Message role ('user' or 'assistant')
            content: Message content
        """
        if user_id not in self.conversations:
            self.conversations[user_id] = []
        
        self.conversations[user_id].append({
            "role": role,
            "content": content
        })
        logger.debug(f"Added {role} message for user {user_id}")
    
    def get_history(self, user_id: int) -> List[Dict]:
        """
        Get the full conversation history for a user
        
        Args:
            user_id: Telegram user ID
            
        Returns:
            List of message dictionaries
        """
        return self.conversations.get(user_id, [])
    
    def clear_history(self, user_id: int) -> None:
        """
        Clear the conversation history for a user
        
        Args:
            user_id: Telegram user ID
        """
        if user_id in self.conversations:
            del self.conversations[user_id]
            logger.info(f"Cleared conversation history for user {user_id}")
    
    def has_history(self, user_id: int) -> bool:
        """
        Check if user has any conversation history
        
        Args:
            user_id: Telegram user ID
            
        Returns:
            True if user has history, False otherwise
        """
        return user_id in self.conversations and len(self.conversations[user_id]) > 0
    
    def get_history_length(self, user_id: int) -> int:
        """
        Get the number of messages in user's history
        
        Args:
            user_id: Telegram user ID
            
        Returns:
            Number of messages in history
        """
        return len(self.conversations.get(user_id, []))
