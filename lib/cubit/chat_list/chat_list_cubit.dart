import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwhatsapp/cubit/chat_list/chat_list_cubit_state.dart';
import 'package:taskwhatsapp/models/chat_model.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(const ChatListState());

  Future<void> loadChats() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final chats = _generateSampleChats();

      emit(state.copyWith(chats: chats, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> refreshChats() async {
    await loadChats();
  }

  List<Chat> _generateSampleChats() {
    final now = DateTime.now();

    return [
      Chat(
        id: '1',
        name: 'Sarah Johnson',
        lastMessage: 'I\'m doing great, thanks!',
        timestamp: now.subtract(const Duration(minutes: 5)),
        avatar: '👩‍💼',
        isOnline: true,
        unreadCount: null,
        isFavorite: true,
        isGroup: false,
      ),
      Chat(
        id: '2',
        name: 'Family Group',
        lastMessage: 'Sure thing! I\'ll be there',
        timestamp: now.subtract(const Duration(minutes: 30)),
        avatar: '👨‍👩‍👧‍👦',
        isOnline: false,
        unreadCount: null,
        isFavorite: true,
        isGroup: true,
      ),
      Chat(
        id: '3',
        name: 'John Smith',
        lastMessage: 'You\'re welcome!',
        timestamp: now.subtract(const Duration(hours: 2)),
        avatar: '👨‍💻',
        isOnline: true,
        unreadCount: null, // No unread messages
        isFavorite: false,
        isGroup: false,
      ),
      Chat(
        id: '4',
        name: 'Work Team',
        lastMessage: 'Thanks',
        timestamp: now.subtract(const Duration(hours: 1)),
        avatar: '💼',
        isOnline: false,
        unreadCount: 1,
        isFavorite: true,
        isGroup: true,
      ),
      Chat(
        id: '5',
        name: 'Emma Wilson',
        lastMessage: 'Yes! Let\'s go to the gallery on Saturday.',
        timestamp: now.subtract(const Duration(minutes: 15)),
        avatar: '👩‍🎨',
        isOnline: false,
        unreadCount: null, // Read
        isFavorite: false,
        isGroup: false,
      ),
      Chat(
        id: '6',
        name: 'Study Group',
        lastMessage: 'Assignment due tomorrow',
        timestamp: now.subtract(const Duration(hours: 3)),
        avatar: '📚',
        isOnline: false,
        unreadCount: 2,
        isFavorite: false,
        isGroup: true,
      ),
      Chat(
        id: '7',
        name: 'Ahmed Ali',
        lastMessage: 'PERFECT, THANKS 🙏',
        timestamp: now.subtract(const Duration(days: 1)),
        avatar: '🧔',
        isOnline: true,
        unreadCount: 1,
        isFavorite: true,
        isGroup: false,
      ),
    ];
  }

  void markChatAsRead(String chatId) {
    final updatedChats = state.chats.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(unreadCount: null);
      }
      return chat;
    }).toList();

    emit(state.copyWith(chats: updatedChats));
  }

  void toggleFavorite(String chatId) {
    final updatedChats = state.chats.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(isFavorite: !chat.isFavorite);
      }
      return chat;
    }).toList();

    emit(state.copyWith(chats: updatedChats));
  }

  void pinChat(String chatId) {
    final updatedChats = state.chats.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(isPinned: !chat.isPinned);
      }
      return chat;
    }).toList();

    // Sort: pinned chats first
    updatedChats.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.timestamp.compareTo(a.timestamp);
    });

    emit(state.copyWith(chats: updatedChats));
  }

  void archiveChat(String chatId) {
    final updatedChats = state.chats.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(isArchived: !chat.isArchived);
      }
      return chat;
    }).toList();

    emit(state.copyWith(chats: updatedChats));
  }
}
