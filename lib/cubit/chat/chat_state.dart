import 'package:equatable/equatable.dart';
import 'package:taskwhatsapp/models/chat_model.dart';
import 'package:taskwhatsapp/models/message_model.dart';

class ChatState extends Equatable {
  final Chat? currentChat;
  final List<Message> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;

  const ChatState({
    this.currentChat,
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  ChatState copyWith({
    Chat? currentChat,
    List<Message>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return ChatState(
      currentChat: currentChat ?? this.currentChat,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    currentChat,
    messages,
    isLoading,
    isSending,
    error,
  ];
}
