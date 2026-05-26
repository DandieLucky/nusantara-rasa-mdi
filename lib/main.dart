import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/map_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chatbot_modal.dart';
import 'screens/login_screen.dart';
import 'screens/admin_panel_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WAJIB: Inisialisasi SQLite FFI untuk Windows/Linux/macOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const NusantaraRasaApp(),
    ),
  );
}

class NusantaraRasaApp extends StatelessWidget {
  const NusantaraRasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusantara Rasa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF8F4),
        primaryColor: const Color(0xFF8B322C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF8F4),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF3E2723)),
          titleTextStyle: TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class MainWrapper extends StatelessWidget {
  final int userId;
  final String userRole;
  final String userName;

  const MainWrapper({
    super.key,
    required this.userId,
    required this.userRole,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    final List<Widget> pages = [
      const HomeScreen(),
      const ExploreScreen(),
      const MapScreen(),
      const FavoriteScreen(),
      const ProfileScreen(),
    ];

    return Stack(
      children: [
        // Background
        Container(color: const Color(0xFFF9F6F0)),
        Opacity(
          opacity: 0.15,
          child: Image.asset(
            'assets/images/bg_nusantara.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            color: const Color(0xFFA84A3B),
            colorBlendMode: BlendMode.srcATop,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
        ),

        // Content
        Scaffold(
          backgroundColor: Colors.transparent,
          body: pages[provider.currentIndex],

          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Admin Panel Button (hanya muncul untuk admin)
              if (userRole == 'admin')
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FloatingActionButton.small(
                    heroTag: 'admin_fab',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminPanelScreen(userId: userId),
                        ),
                      );
                    },
                    backgroundColor: const Color(0xFF3E2723),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              // Chatbot Button
              FloatingActionButton(
                heroTag: 'chatbot_fab',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const ChatbotModal(),
                  );
                },
                backgroundColor: const Color(0xFFA84A3B),
                elevation: 4,
                child: const Icon(Icons.support_agent, color: Colors.white),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: provider.currentIndex,
              onTap: (index) => provider.setIndex(index),
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF8B322C),
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 11,
              ),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_rounded),
                  label: 'Favorite',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
