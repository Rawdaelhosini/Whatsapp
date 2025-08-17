import 'package:equatable/equatable.dart';

enum MessageStatus { sending, sent, delivered, read, failed }

class Message extends Equatable {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSent;
  final MessageStatus? status;
  final String? imageUrl;
  final String? replyToId;

  const Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isSent,
    this.status,
    this.imageUrl,
    this.replyToId,
  });

  Message copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    bool? isSent,
    MessageStatus? status,
    String? imageUrl,
    String? replyToId,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isSent: isSent ?? this.isSent,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      replyToId: replyToId ?? this.replyToId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    timestamp,
    isSent,
    status,
    imageUrl,
    replyToId,
  ];

  bool get isReceived => !isSent;
  bool get hasImage => imageUrl != null;
  bool get isReply => replyToId != null;

  String get statusIcon {
    if (!isSent) return '';

    switch (status) {
      case MessageStatus.sending:
        return '🕐';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.read:
        return '✓✓';
      case MessageStatus.failed:
        return '❌';
      case null:
        return '';
    }
  }
}
