import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:taskwhatsapp/models/message_model.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';

class MessageBubble extends StatefulWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slideAnimation = Tween<Offset>(
      begin: widget.message.isSent ? const Offset(1, 0) : const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: widget.message.isSent
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!widget.message.isSent) const SizedBox(width: 50),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: widget.message.isSent
                        ? isDark
                              ? WhatsAppTheme.darkBubbleSent
                              : WhatsAppTheme.lightBubbleSent
                        : isDark
                        ? WhatsAppTheme.darkBubbleReceived
                        : WhatsAppTheme.lightBubbleReceived,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.message.isSent ? 18 : 4),
                      topRight: Radius.circular(widget.message.isSent ? 4 : 18),
                      bottomLeft: const Radius.circular(18),
                      bottomRight: const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.message.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? WhatsAppTheme.darkText
                              : WhatsAppTheme.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat(
                              'HH:mm',
                            ).format(widget.message.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? WhatsAppTheme.darkTextSecondary.withOpacity(
                                      0.7,
                                    )
                                  : WhatsAppTheme.lightTextSecondary
                                        .withOpacity(0.7),
                            ),
                          ),
                          if (widget.message.isSent) const SizedBox(width: 4),
                          if (widget.message.isSent)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _buildStatusIcon(isDark),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.message.isSent) const SizedBox(width: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(bool isDark) {
    IconData icon;
    Color color;

    switch (widget.message.status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = isDark
            ? WhatsAppTheme.darkTextSecondary
            : WhatsAppTheme.lightTextSecondary;
        break;
      case MessageStatus.sent:
        icon = Icons.done;
        color = isDark
            ? WhatsAppTheme.darkTextSecondary
            : WhatsAppTheme.lightTextSecondary;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = isDark
            ? WhatsAppTheme.darkTextSecondary
            : WhatsAppTheme.lightTextSecondary;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = WhatsAppTheme.tealGreen;
        break;
      case null:
        // TODO: Handle this case.
        throw UnimplementedError();
      case MessageStatus.failed:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Icon(icon, size: 14, color: color);
  }
}
