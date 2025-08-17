import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String id;
  final String name;
  final String? lastMessage;
  final DateTime timestamp;
  final String avatar;
  final bool isOnline;

  final int? unreadCount;
  final bool isFavorite;
  final bool isGroup;
  final bool isPinned;
  final bool isArchived;
  final bool isMuted;

  const Chat({
    required this.id,
    required this.name,
    this.lastMessage,
    required this.timestamp,
    required this.avatar,
    this.isOnline = false,
    this.unreadCount,
    this.isFavorite = false,
    this.isGroup = false,
    this.isPinned = false,
    this.isArchived = false,
    this.isMuted = false,
  });

  Chat copyWith({
    String? id,
    String? name,
    String? lastMessage,
    DateTime? timestamp,
    String? avatar,
    bool? isOnline,
    int? unreadCount,
    bool? isFavorite,
    bool? isGroup,
    bool? isPinned,
    bool? isArchived,
    bool? isMuted,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      unreadCount: unreadCount ?? this.unreadCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isGroup: isGroup ?? this.isGroup,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    lastMessage,
    timestamp,
    avatar,
    isOnline,
    unreadCount,
    isFavorite,
    isGroup,
    isPinned,
    isArchived,
    isMuted,
  ];

  bool get hasUnreadMessages => unreadCount != null && unreadCount! > 0;
  bool get isRead => !hasUnreadMessages;

  String get unreadBadge {
    if (unreadCount == null || unreadCount! <= 0) return '';
    if (unreadCount! > 99) return '99+';
    return unreadCount!.toString();
  }
}
