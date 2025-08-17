enum ChatFilter { all, unread, favorites, groups }

extension ChatFilterExtension on ChatFilter {
  String get displayName {
    switch (this) {
      case ChatFilter.all:
        return 'All';
      case ChatFilter.unread:
        return 'Unread';
      case ChatFilter.favorites:
        return 'Favorites';
      case ChatFilter.groups:
        return 'Groups';
    }
  }
}
