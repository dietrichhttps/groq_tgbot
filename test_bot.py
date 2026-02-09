"""
Tests for the ChatGPT Telegram Bot

To run tests, use:
    python -m pytest test_bot.py -v
"""

import unittest
from unittest.mock import MagicMock, patch
from dialogue_manager import DialogueManager


class TestDialogueManager(unittest.TestCase):
    """Test cases for DialogueManager class"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.manager = DialogueManager()
        self.user_id = 12345
    
    def test_add_message(self):
        """Test adding messages to conversation history"""
        self.manager.add_message(self.user_id, "user", "Hello")
        self.manager.add_message(self.user_id, "assistant", "Hi there!")
        
        history = self.manager.get_history(self.user_id)
        self.assertEqual(len(history), 2)
        self.assertEqual(history[0]["role"], "user")
        self.assertEqual(history[0]["content"], "Hello")
        self.assertEqual(history[1]["role"], "assistant")
        self.assertEqual(history[1]["content"], "Hi there!")
    
    def test_get_history_empty(self):
        """Test getting history for user with no messages"""
        history = self.manager.get_history(self.user_id)
        self.assertEqual(len(history), 0)
        self.assertEqual(history, [])
    
    def test_clear_history(self):
        """Test clearing conversation history"""
        # Add some messages
        self.manager.add_message(self.user_id, "user", "Hello")
        self.manager.add_message(self.user_id, "assistant", "Hi!")
        
        # Verify messages exist
        self.assertTrue(self.manager.has_history(self.user_id))
        self.assertEqual(self.manager.get_history_length(self.user_id), 2)
        
        # Clear history
        self.manager.clear_history(self.user_id)
        
        # Verify history is cleared
        self.assertFalse(self.manager.has_history(self.user_id))
        self.assertEqual(self.manager.get_history_length(self.user_id), 0)
    
    def test_has_history(self):
        """Test checking if user has conversation history"""
        self.assertFalse(self.manager.has_history(self.user_id))
        
        self.manager.add_message(self.user_id, "user", "Hello")
        self.assertTrue(self.manager.has_history(self.user_id))
        
        self.manager.clear_history(self.user_id)
        self.assertFalse(self.manager.has_history(self.user_id))
    
    def test_multiple_users(self):
        """Test managing conversations for multiple users"""
        user1 = 11111
        user2 = 22222
        
        self.manager.add_message(user1, "user", "Hello from user1")
        self.manager.add_message(user2, "user", "Hello from user2")
        
        history1 = self.manager.get_history(user1)
        history2 = self.manager.get_history(user2)
        
        self.assertEqual(len(history1), 1)
        self.assertEqual(len(history2), 1)
        self.assertEqual(history1[0]["content"], "Hello from user1")
        self.assertEqual(history2[0]["content"], "Hello from user2")


if __name__ == '__main__':
    unittest.main()
