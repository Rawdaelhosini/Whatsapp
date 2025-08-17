import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwhatsapp/cubit/stories/stories_state.dart';
import 'package:taskwhatsapp/models/story_model.dart';

class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(const StoriesState());

  Future<void> loadStories() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final stories = _generateDummyStories();
      emit(state.copyWith(stories: stories, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void viewStory(int storyIndex, int itemIndex) {
    emit(
      state.copyWith(
        currentStoryIndex: storyIndex,
        currentItemIndex: itemIndex,
      ),
    );
  }

  void nextStoryItem() {
    if (state.currentStoryIndex == null || state.currentItemIndex == null)
      return;

    final currentStory = state.stories[state.currentStoryIndex!];
    final nextItemIndex = state.currentItemIndex! + 1;

    if (nextItemIndex < currentStory.items.length) {
      emit(state.copyWith(currentItemIndex: nextItemIndex));
    } else {
      // Move to next story
      final nextStoryIndex = state.currentStoryIndex! + 1;
      if (nextStoryIndex < state.stories.length) {
        emit(
          state.copyWith(
            currentStoryIndex: nextStoryIndex,
            currentItemIndex: 0,
          ),
        );
      } else {
        // End of stories
        emit(state.copyWith(currentStoryIndex: null, currentItemIndex: null));
      }
    }
  }

  void closeStoryViewer() {
    emit(state.copyWith(currentStoryIndex: null, currentItemIndex: null));
  }

  List<Story> _generateDummyStories() {
    return [
      const Story(id: '1', userName: 'My Status', avatar: '🤳', items: []),
      Story(
        id: '2',
        userName: 'Sarah Johnson',
        avatar: '👩‍💼',
        items: [
          StoryItem(
            id: '1',
            imageUrl: 'https://picsum.photos/300/500',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      Story(
        id: '3',
        userName: 'John Smith',
        avatar: '👨‍💻',
        items: [
          StoryItem(
            id: '2',
            imageUrl: 'https://picsum.photos/300/501',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
        isViewed: true,
      ),
      Story(
        id: '4',
        userName: 'Emma Wilson',
        avatar: '👩‍🎨',
        items: [
          StoryItem(
            id: '3',
            imageUrl: 'https://picsum.photos/300/502',
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          ),
        ],
      ),
    ];
  }
}
