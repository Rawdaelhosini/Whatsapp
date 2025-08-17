import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwhatsapp/chatfilterenum.dart';
import 'package:taskwhatsapp/cubit/chat_list/chat_list_cubit.dart';
import 'package:taskwhatsapp/cubit/chat_list/chat_list_cubit_state.dart';
import 'package:taskwhatsapp/screens/chat_screen.dart';
import 'package:taskwhatsapp/theme/theme_cubit.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';
import 'package:taskwhatsapp/widgets/animated_chat_tile_widgets.dart';
import 'package:taskwhatsapp/widgets/build_filter_chip.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key, required ChatFilter filter}) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  ChatFilter _selectedFilter = ChatFilter.all;

  void _onFilterChanged(ChatFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.currentTheme == AppTheme.dark;

        return BlocBuilder<ChatListCubit, ChatListState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(child: Text('New group')),
                          const PopupMenuItem(child: Text('New broadcast')),
                          const PopupMenuItem(child: Text('Linked devices')),
                          const PopupMenuItem(child: Text('Settings')),
                        ],
                        icon: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? WhatsAppTheme.darkContainer
                                : WhatsAppTheme.lightContainer,
                          ),
                          child: const Icon(Icons.more_horiz),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? WhatsAppTheme.darkContainer
                                  : WhatsAppTheme.lightContainer,
                            ),
                            child: const Icon(Icons.camera_alt, size: 20),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                            child: Container(
                              // width: 40,
                              // height: 25,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: WhatsAppTheme.lightGreen,
                              ),
                              child: Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ],
                  ),
                ),

                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Chats',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? WhatsAppTheme.darkContainer
                          : WhatsAppTheme.lightContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          "Ask Meta AI or Search",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter chips
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: BlocBuilder<ChatListCubit, ChatListState>(
                    builder: (context, state) {
                      final chats = state.chats;
                      final unreadCount = chats
                          .where(
                            (c) => c.unreadCount != null && c.unreadCount! > 0,
                          )
                          .length;
                      final favoriteCount = chats
                          .where((c) => c.isFavorite)
                          .length;
                      final groupsCount = chats.where((c) => c.isGroup).length;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            BuildFilterChip(
                              label: "All",
                              isSelected: _selectedFilter == ChatFilter.all,
                              onTap: () => _onFilterChanged(ChatFilter.all),
                              isDark: isDark,
                            ),
                            BuildFilterChip(
                              label:
                                  "Unread ${unreadCount > 0 ? '$unreadCount' : ''}",
                              isSelected: _selectedFilter == ChatFilter.unread,
                              onTap: () => _onFilterChanged(ChatFilter.unread),
                              isDark: isDark,
                            ),
                            BuildFilterChip(
                              label:
                                  "Favorites ${favoriteCount > 0 ? '$favoriteCount' : ''}",
                              isSelected:
                                  _selectedFilter == ChatFilter.favorites,
                              onTap: () =>
                                  _onFilterChanged(ChatFilter.favorites),
                              isDark: isDark,
                            ),
                            BuildFilterChip(
                              label:
                                  "Groups ${groupsCount > 0 ? '$groupsCount' : ''}",
                              isSelected: _selectedFilter == ChatFilter.groups,
                              onTap: () => _onFilterChanged(ChatFilter.groups),
                              isDark: isDark,
                            ),
                            _buildAddChip(isDark),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Chat List
                Expanded(child: _buildChatList(context, state)),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildChatList(BuildContext context, ChatListState state) {
    if (state.isLoading && state.chats.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            ElevatedButton(
              onPressed: () => context.read<ChatListCubit>().loadChats(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filteredChats = _getFilteredChats(state.chats);

    if (filteredChats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getFilterIcon(), size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessage(),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ChatListCubit>().refreshChats(),
      child: ListView.builder(
        itemCount: filteredChats.length,
        itemBuilder: (context, index) {
          final chat = filteredChats[index];

          return AnimatedChatTile(
            chat: chat,
            index: index,
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  settings: RouteSettings(
                    name: '/chat/${chat.id}',
                    arguments: chat,
                  ),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ChatScreen(chatId: chat.id);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: child,
                        );
                      },
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<dynamic> _getFilteredChats(List<dynamic> chats) {
    switch (_selectedFilter) {
      case ChatFilter.all:
        return chats;
      case ChatFilter.unread:
        return chats
            .where((chat) => chat.unreadCount != null && chat.unreadCount! > 0)
            .toList();
      case ChatFilter.favorites:
        return chats.where((chat) => chat.isFavorite == true).toList();
      case ChatFilter.groups:
        return chats.where((chat) => chat.isGroup == true).toList();
    }
  }

  Widget _buildAddChip(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark
            ? WhatsAppTheme.darkContainer
            : WhatsAppTheme.lightContainer,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, size: 20),
    );
  }

  IconData _getFilterIcon() {
    switch (_selectedFilter) {
      case ChatFilter.all:
        return Icons.chat_bubble_outline;
      case ChatFilter.unread:
        return Icons.mark_chat_unread;
      case ChatFilter.favorites:
        return Icons.favorite_border;
      case ChatFilter.groups:
        return Icons.groups_outlined;
    }
  }

  String _getEmptyMessage() {
    switch (_selectedFilter) {
      case ChatFilter.all:
        return 'No chats available';
      case ChatFilter.unread:
        return 'No unread messages\nYou\'re all caught up! 🎉';
      case ChatFilter.favorites:
        return 'No favorite chats\nStar important chats to find them here';
      case ChatFilter.groups:
        return 'No group chats\nCreate a group to get started';
    }
  }
}
