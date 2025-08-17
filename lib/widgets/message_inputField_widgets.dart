import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;

  const MessageInputField({
    Key? key,
    required this.onSendMessage,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonScale;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);

    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _sendButtonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.elasticOut),
    );
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
      if (hasText) {
        _sendButtonController.forward();
      } else {
        _sendButtonController.reverse();
      }
    }
  }

  void _sendMessage() {
    if (_hasText && !widget.isLoading) {
      final message = _controller.text.trim();
      _controller.clear();
      setState(() {
        _hasText = false;
      });
      _sendButtonController.reverse();
      widget.onSendMessage(message);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? WhatsAppTheme.darkBackground
            : WhatsAppTheme.lightBackground,
        border: Border(
          top: BorderSide(
            color: isDark
                ? WhatsAppTheme.darkSurface
                : WhatsAppTheme.lightSurface,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? WhatsAppTheme.darkSurface
                    : WhatsAppTheme.lightSurface,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: isDark
                          ? WhatsAppTheme.darkTextSecondary
                          : WhatsAppTheme.lightTextSecondary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(
                          color: isDark
                              ? WhatsAppTheme.darkTextSecondary
                              : WhatsAppTheme.lightTextSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark
                            ? WhatsAppTheme.darkText
                            : WhatsAppTheme.lightText,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.attach_file,
                      color: isDark
                          ? WhatsAppTheme.darkTextSecondary
                          : WhatsAppTheme.lightTextSecondary,
                    ),
                  ),
                  if (!_hasText)
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt,
                        color: isDark
                            ? WhatsAppTheme.darkTextSecondary
                            : WhatsAppTheme.lightTextSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ScaleTransition(
            scale: _sendButtonScale,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: WhatsAppTheme.lightGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: Icon(
                  widget.isLoading ? Icons.access_time : Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
