import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/map_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chatbot_modal.dart';
import 'screens/login_screen.dart'; // <-- Tambahan import halaman login
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase gagal diinisialisasi atau belum dikonfigurasi: $e");
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
        // Mengubah background menjadi krem hangat sesuai desain Figma
        scaffoldBackgroundColor: const Color(0xFFFAF8F4),
        primaryColor: const Color(0xFF8B322C), // Warna aksen merah bata
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF8F4),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF3E2723)), // Cokelat gelap
          titleTextStyle: TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // --- UBAH DI SINI: Aplikasi akan membuka LoginScreen pertama kali ---
      home: const LoginScreen(),
    );
  }
}

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    // Sekarang kita siapkan 5 slot halaman sesuai Figma
    final List<Widget> pages = [
      const HomeScreen(),
      const ExploreScreen(),
      const MapScreen(),
      const FavoriteScreen(),
      const ProfileScreen(),
    ];

    return Stack(
      children: [
        // --- 1. BACKGROUND UNIVERSAL UNTUK SEMUA HALAMAN ---
        Container(color: const Color(0xFFF9F6F0)), // Krem dasar
        Opacity(
          opacity: 0.15,
          child: Image.asset(
            'assets/images/bg_nusantara.jpg', // Motif batik
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            color: const Color(0xFFA84A3B),
            colorBlendMode: BlendMode.srcATop,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
        ),

        // --- 2. KONTEN APLIKASI (SCAFFOLD TRANSPARAN) ---
        Scaffold(
          backgroundColor: Colors
              .transparent, // Wajib transparan agar background belakang terlihat
          body: pages[provider.currentIndex],

          floatingActionButton: FloatingActionButton(
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
