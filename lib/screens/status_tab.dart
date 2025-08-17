import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwhatsapp/cubit/stories/stories_cubit.dart';
import 'package:taskwhatsapp/cubit/stories/stories_state.dart';
import 'package:taskwhatsapp/widgets/story_avatar.widgets.dart';
import 'package:taskwhatsapp/widgets/storywiewer_widgets.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';

class StatusTab extends StatelessWidget {
  final bool isDark;

  const StatusTab({Key? key, this.isDark = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => StoriesCubit()..loadStories(),
      child: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  ElevatedButton(
                    onPressed: () => context.read<StoriesCubit>().loadStories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton(
                        elevation: 0,
                        itemBuilder: (context) => const [
                          PopupMenuItem(child: Text('New group')),
                          PopupMenuItem(child: Text('New broadcast')),
                          PopupMenuItem(child: Text('Linked devices')),
                          PopupMenuItem(child: Text('Settings')),
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
                    ],
                  ),
                ),

                // 🔹 Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'Updates',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                ),
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
                          "Search",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
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
                          child: Icon(Icons.camera_alt, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? WhatsAppTheme.darkContainer
                                : WhatsAppTheme.lightContainer,
                          ),
                          child: Icon(Icons.mode_edit_rounded, size: 20),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),

                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.stories.length,
                    itemBuilder: (context, index) {
                      final story = state.stories[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: StoryAvatar(
                          story: story,
                          onTap: () {
                            if (story.id == '1') {
                              // "My Status" tap
                              return;
                            }

                            if (story.items.isNotEmpty) {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => StoryViewer(
                                        stories: state.stories
                                            .where((s) => s.items.isNotEmpty)
                                            .toList(),
                                        initialStoryIndex: state.stories
                                            .where((s) => s.items.isNotEmpty)
                                            .toList()
                                            .indexWhere(
                                              (s) => s.id == story.id,
                                            ),
                                        initialItemIndex: 0,
                                        onClose: () => Navigator.pop(context),
                                      ),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale:
                                                Tween<double>(
                                                  begin: 0.8,
                                                  end: 1.0,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeOut,
                                                  ),
                                                ),
                                            child: child,
                                          ),
                                        );
                                      },
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),

                Expanded(
                  child: Center(
                    child: Text(
                      'No recent updates to show',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
