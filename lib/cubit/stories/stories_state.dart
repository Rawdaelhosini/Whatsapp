import 'package:equatable/equatable.dart';
import 'package:taskwhatsapp/models/story_model.dart';

class StoriesState extends Equatable {
  final List<Story> stories;
  final bool isLoading;
  final int? currentStoryIndex;
  final int? currentItemIndex;
  final String? error;

  const StoriesState({
    this.stories = const [],
    this.isLoading = false,
    this.currentStoryIndex,
    this.currentItemIndex,
    this.error,
  });

  StoriesState copyWith({
    List<Story>? stories,
    bool? isLoading,
    int? currentStoryIndex,
    int? currentItemIndex,
    String? error,
  }) {
    return StoriesState(
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
      currentItemIndex: currentItemIndex ?? this.currentItemIndex,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    stories,
    isLoading,
    currentStoryIndex,
    currentItemIndex,
    error,
  ];
}
