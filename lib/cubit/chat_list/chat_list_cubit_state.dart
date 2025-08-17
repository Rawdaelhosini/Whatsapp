import 'package:equatable/equatable.dart';
import 'package:taskwhatsapp/models/chat_model.dart';

class ChatListState extends Equatable {
  final List<Chat> chats;
  final bool isLoading;
  final String? error;

  const ChatListState({
    this.chats = const [],
    this.isLoading = false,
    this.error,
  });

  ChatListState copyWith({List<Chat>? chats, bool? isLoading, String? error}) {
    return ChatListState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [chats, isLoading, error];
}
