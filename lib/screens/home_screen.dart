import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwhatsapp/chatfilterenum.dart';
import 'package:taskwhatsapp/cubit/chat_list/chat_list_cubit.dart';
import 'package:taskwhatsapp/screens/chats_tab.dart';
import 'package:taskwhatsapp/screens/status_tab.dart';
import 'package:taskwhatsapp/theme/theme_cubit.dart';
import 'package:taskwhatsapp/theme/whatsapp_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 3;
  late TabController _tabController;
  ChatFilter _selectedFilter = ChatFilter.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // تحميل البيانات
    context.read<ChatListCubit>().loadChats();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const StatusTab();
      case 1:
        return const Center(child: Text("Calls Screen"));
      case 2:
        return const Center(child: Text("Communities Screen"));
      case 3:
        return ChatsTab(filter: _selectedFilter);
      case 4:
        return const Center(child: Text("Settings Screen"));
      default:
        return ChatsTab(filter: _selectedFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.currentTheme == AppTheme.dark;

        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(child: _getCurrentScreen())],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: isDark
                ? WhatsAppTheme.darkContainer
                : WhatsAppTheme.lightContainer,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: isDark
                ? WhatsAppTheme.lightBackground
                : WhatsAppTheme.darkBackground,
            unselectedItemColor: const Color(0xff696b6a),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/update.png',
                  color: const Color(0xff696b6a),
                ),
                activeIcon: Image.asset(
                  'assets/images/update.png',
                  color: isDark ? WhatsAppTheme.lightGreen : Colors.black,
                ),
                label: "Updates",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.call),
                label: "Calls",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.groups),
                label: "Communities",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: "Chats",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        );
      },
    );
  }
}
