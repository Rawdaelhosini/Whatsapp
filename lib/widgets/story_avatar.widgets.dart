import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskwhatsapp/models/story_model.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';

class StoryAvatar extends StatefulWidget {
  final Story story;
  final VoidCallback onTap;

  const StoryAvatar({Key? key, required this.story, required this.onTap})
    : super(key: key);

  @override
  State<StoryAvatar> createState() => _StoryAvatarState();
}

class _StoryAvatarState extends State<StoryAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.story.items.isNotEmpty && !widget.story.isViewed) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasStory = widget.story.items.isNotEmpty;

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 85,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fix 2: Use minimum space needed
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: hasStory && !widget.story.isViewed
                      ? _pulseAnimation.value
                      : 1.0,
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasStory && !widget.story.isViewed
                          ? const LinearGradient(
                              colors: [
                                WhatsAppTheme.lightGreen,
                                WhatsAppTheme.tealGreen,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      border: widget.story.isViewed && hasStory
                          ? Border.all(
                              color: isDark
                                  ? WhatsAppTheme.darkTextSecondary
                                  : WhatsAppTheme.lightTextSecondary,
                              width: 2,
                            )
                          : null,
                    ),
                    padding: EdgeInsets.all(hasStory ? 3 : 0),
                    child: CircleAvatar(
                      radius: hasStory ? 28 : 32.5,
                      backgroundColor: isDark
                          ? WhatsAppTheme.darkSurface
                          : WhatsAppTheme.lightSurface,
                      child: widget.story.id == '1'
                          ? Stack(
                              children: [
                                Text(
                                  widget.story.avatar,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: WhatsAppTheme.lightGreen,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? WhatsAppTheme.darkBackground
                                            : WhatsAppTheme.lightBackground,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              widget.story.avatar,
                              style: const TextStyle(fontSize: 28),
                            ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            Flexible(
              child: SizedBox(
                width: 70,
                child: Text(
                  widget.story.userName,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? WhatsAppTheme.darkText
                        : WhatsAppTheme.lightText,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
