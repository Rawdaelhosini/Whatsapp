import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwhatsapp/cubit/chat/chat_state.dart';
import 'package:taskwhatsapp/models/chat_model.dart';
import 'package:taskwhatsapp/models/message_model.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState());

  Future<void> loadChat(String chatId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final chat = _getChatById(chatId);
      final messages = _getMessagesForChat(chatId);

      emit(
        state.copyWith(currentChat: chat, messages: messages, isLoading: false),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty || state.currentChat == null) {
      return;
    }

    emit(state.copyWith(isSending: true));

    try {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: messageText.trim(),
        timestamp: DateTime.now(),
        isSent: true,
        status: MessageStatus.sending,
      );

      // Add message to current messages
      final updatedMessages = [...state.messages, newMessage];

      emit(state.copyWith(messages: updatedMessages, isSending: false));

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Update message status to delivered
      final deliveredMessage = newMessage.copyWith(
        status: MessageStatus.delivered,
      );
      final finalMessages = updatedMessages
          .map((msg) => msg.id == newMessage.id ? deliveredMessage : msg)
          .toList();

      emit(state.copyWith(messages: finalMessages));

      // Simulate read after 1 second
      await Future.delayed(const Duration(seconds: 1));

      final readMessage = deliveredMessage.copyWith(status: MessageStatus.read);
      final readMessages = finalMessages
          .map((msg) => msg.id == newMessage.id ? readMessage : msg)
          .toList();

      emit(state.copyWith(messages: readMessages));
    } catch (e) {
      // Handle error - maybe show the message as failed
      emit(
        state.copyWith(isSending: false, error: 'Failed to send message: $e'),
      );
    }
  }

  Chat _getChatById(String chatId) {
    final chatData = {
      '1': {'name': 'Sarah Johnson', 'avatar': '👩‍💼', 'isOnline': true},
      '2': {'name': 'Family Group', 'avatar': '👨‍👩‍👧‍👦', 'isOnline': false},
      '3': {'name': 'John Smith', 'avatar': '👨‍💻', 'isOnline': true},
      '4': {'name': 'Work Team', 'avatar': '💼', 'isOnline': false},
      '5': {'name': 'Emma Wilson', 'avatar': '👩‍🎨', 'isOnline': false},
      '6': {'name': 'Study Group', 'avatar': '📚', 'isOnline': false},
      '7': {'name': 'Ahmed Ali', 'avatar': '🧔', 'isOnline': true},
    };

    final data = chatData[chatId] ?? chatData['1']!;

    return Chat(
      id: chatId,
      name: data['name'] as String,
      lastMessage: 'Last message...',
      timestamp: DateTime.now(),
      avatar: data['avatar'] as String,
      isOnline: data['isOnline'] as bool,
    );
  }

  List<Message> _getMessagesForChat(String chatId) {
    final messagesData = {
      '1': [
        Message(
          id: '1',
          text: 'Hey! How are you doing? 😊',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isSent: false,
        ),
        Message(
          id: '2',
          text: 'I\'m doing great, thanks!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          isSent: true,
          status: MessageStatus.read,
        ),
      ],
      '2': [
        Message(
          id: '3',
          text: 'Mom: Don\'t forget dinner tomorrow!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isSent: false,
        ),
        Message(
          id: '4',
          text: 'Sure thing! I\'ll be there',
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isSent: true,
          status: MessageStatus.delivered,
        ),
      ],
      '3': [
        Message(
          id: '5',
          text: 'Thanks for the documents 👍',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isSent: false,
        ),
        Message(
          id: '6',
          text: 'You\'re welcome!',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isSent: true,
          status: MessageStatus.read,
        ),
      ],
      '4': [
        Message(
          id: '7',
          text: 'Meeting at 10 AM tomorrow.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isSent: false,
        ),
        Message(
          id: '8',
          text: 'Got it, I\'ll prepare the slides.',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 4, minutes: 45),
          ),
          isSent: true,
          status: MessageStatus.delivered,
        ),
        Message(
          id: '9',
          text: 'Can you also send me the agenda points?',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 2, minutes: 30),
          ),
          isSent: false,
        ),
        Message(
          id: '10',
          text: 'Sure, I\'ll email them shortly.',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 2, minutes: 20),
          ),
          isSent: true,
          status: MessageStatus.read,
        ),
        Message(
          id: '11',
          text: 'Thanks',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isSent: false,
        ),
      ],

      '5': [
        Message(
          id: '12',
          text: 'Hey Emma, are you free this weekend? 🎨',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          isSent: true,
          status: MessageStatus.read,
        ),
        Message(
          id: '13',
          text: 'Yes! Let\'s go to the gallery on Saturday.',
          timestamp: DateTime.now().subtract(
            const Duration(days: 1, hours: 1, minutes: 40),
          ),
          isSent: false,
        ),
      ],
      '6': [
        Message(
          id: '14',
          text: 'Don\'t forget the homework assignment!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
          isSent: false,
        ),
        Message(
          id: '15',
          text: 'Thanks, I almost forgot 😅',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          isSent: true,
          status: MessageStatus.read,
        ),
        Message(
          id: '16',
          text: 'Hey, are you coming to the group study later? 📚',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isSent: false,
        ),
        Message(
          id: '17',
          text: 'Assignment due tomorrow',
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          isSent: false,
        ),
      ],
      '7': [
        Message(
          id: '18',
          text: 'Hello! Do you need any help?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
          isSent: true,
          status: MessageStatus.read,
        ),
        Message(
          id: '19',
          text: 'Yes, I had an issue with my order.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          isSent: false,
        ),
        Message(
          id: '20',
          text: 'No worries, it has been fixed! ✅',
          timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
          isSent: true,
          status: MessageStatus.read,
        ),
        Message(
          id: '21',
          text: 'PERFECT, THANKS 🙏',
          timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
          isSent: false,
        ),
      ],
    };

    return messagesData[chatId] ?? [];
  }

  void deleteMessage(String messageId) {
    final updatedMessages = state.messages
        .where((msg) => msg.id != messageId)
        .toList();
    emit(state.copyWith(messages: updatedMessages));
  }

  void updateMessageStatus(String messageId, MessageStatus status) {
    final updatedMessages = state.messages
        .map((msg) => msg.id == messageId ? msg.copyWith(status: status) : msg)
        .toList();
    emit(state.copyWith(messages: updatedMessages));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
