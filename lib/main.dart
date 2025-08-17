import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwhatsapp/cubit/chat_list/chat_list_cubit.dart';

import 'package:taskwhatsapp/screens/home_screen.dart';
import 'package:taskwhatsapp/theme/theme_cubit.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => ChatListCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'WhatsApp Clone',
            theme: WhatsAppTheme.lightTheme,
            darkTheme: WhatsAppTheme.darkTheme,
            themeMode: themeState.themeMode,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
