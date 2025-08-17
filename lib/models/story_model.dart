import 'package:equatable/equatable.dart';

class Story extends Equatable {
  final String id;
  final String userName;
  final String avatar;
  final List<StoryItem> items;
  final bool isViewed;

  const Story({
    required this.id,
    required this.userName,
    required this.avatar,
    required this.items,
    this.isViewed = false,
  });

  @override
  List<Object?> get props => [id, userName, avatar, items, isViewed];
}

class StoryItem extends Equatable {
  final String id;
  final String imageUrl;
  final DateTime timestamp;

  const StoryItem({
    required this.id,
    required this.imageUrl,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, imageUrl, timestamp];
}
