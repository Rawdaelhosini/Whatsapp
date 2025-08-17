import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwhatsapp/cubit/chat/chat_cubit.dart';
import 'package:taskwhatsapp/cubit/chat/chat_state.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';
import 'package:taskwhatsapp/widgets/message_bubble_widgets.dart';
import 'package:taskwhatsapp/widgets/message_inputField_widgets.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => ChatCubit()..loadChat(chatId),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state.currentChat == null) {
                return const Text('Loading...');
              }

              final chat = state.currentChat!;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isDark
                        ? WhatsAppTheme.darkSurface
                        : WhatsAppTheme.lightSurface,
                    child: Text(
                      chat.avatar,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (chat.isOnline)
                          Text(
                            'online',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/chat_background.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                (isDark
                        ? WhatsAppTheme.darkBackground
                        : WhatsAppTheme.lightBackground)
                    .withOpacity(0.9),
                BlendMode.overlay,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
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
                              onPressed: () =>
                                  context.read<ChatCubit>().loadChat(chatId),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(message: state.messages[index]);
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return MessageInputField(
                    onSendMessage: (message) =>
                        context.read<ChatCubit>().sendMessage(message),
                    isLoading: state.isSending,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
