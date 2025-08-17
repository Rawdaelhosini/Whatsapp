import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskwhatsapp/models/story_model.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';

class StoryViewer extends StatefulWidget {
  final List<Story> stories;
  final int initialStoryIndex;
  final int initialItemIndex;
  final VoidCallback onClose;

  const StoryViewer({
    Key? key,
    required this.stories,
    required this.initialStoryIndex,
    required this.initialItemIndex,
    required this.onClose,
  }) : super(key: key);

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with TickerProviderStateMixin {
  late int currentStoryIndex;
  late int currentItemIndex;
  late AnimationController _progressController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    currentStoryIndex = widget.initialStoryIndex;
    currentItemIndex = widget.initialItemIndex;

    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _startProgress();
    _scaleController.forward();
  }

  void _startProgress() {
    _progressController.reset();
    _progressController.forward().then((_) {
      _nextItem();
    });
  }

  void _nextItem() {
    final currentStory = widget.stories[currentStoryIndex];
    if (currentItemIndex < currentStory.items.length - 1) {
      setState(() {
        currentItemIndex++;
      });
      _startProgress();
    } else {
      _nextStory();
    }
  }

  void _nextStory() {
    if (currentStoryIndex < widget.stories.length - 1) {
      setState(() {
        currentStoryIndex++;
        currentItemIndex = 0;
      });
      _startProgress();
    } else {
      widget.onClose();
    }
  }

  void _previousItem() {
    if (currentItemIndex > 0) {
      setState(() {
        currentItemIndex--;
      });
      _startProgress();
    } else {
      _previousStory();
    }
  }

  void _previousStory() {
    if (currentStoryIndex > 0) {
      setState(() {
        currentStoryIndex--;
        currentItemIndex = widget.stories[currentStoryIndex].items.length - 1;
      });
      _startProgress();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = widget.stories[currentStoryIndex];
    final hasItems = currentStory.items.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapUp: (details) {
            final width = MediaQuery.of(context).size.width;
            if (details.localPosition.dx < width / 2) {
              _previousItem();
            } else {
              _nextItem();
            }
          },
          child: Stack(
            children: [
              // Background image or color
              if (hasItems)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF667781), Color(0xFF2A2A2A)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '📷',
                      style: TextStyle(
                        fontSize: 100,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: WhatsAppTheme.darkSurface,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentStory.avatar,
                          style: const TextStyle(fontSize: 100),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No status available',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Progress bars
                      if (hasItems)
                        Row(
                          children: List.generate(
                            currentStory.items.length,
                            (index) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                height: 2,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                child: AnimatedBuilder(
                                  animation: _progressController,
                                  builder: (context, child) {
                                    double progress = 0.0;
                                    if (index < currentItemIndex) {
                                      progress = 1.0;
                                    } else if (index == currentItemIndex) {
                                      progress = _progressController.value;
                                    }
                                    return LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.transparent,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: WhatsAppTheme.darkSurface,
                            child: Text(
                              currentStory.avatar,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentStory.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (hasItems)
                                  Text(
                                    _formatStoryTime(
                                      currentStory
                                          .items[currentItemIndex]
                                          .timestamp,
                                    ),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: widget.onClose,
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatStoryTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
