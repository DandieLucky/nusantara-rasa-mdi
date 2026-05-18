import 'dart:ui';
import 'package:flutter/material.dart';
import 'food_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final Color textDark = const Color(0xFF3E2723);
  final Color textLight = const Color(0xFF8B7360);
  final Color rustRed = const Color(0xFFA84A3B);

  String _searchQuery = '';

  final List<Map<String, String>> _favoriteFoods = [
    {
      'name': 'Rendang',
      'daerah': 'Sumatera Barat',
      'img': 'assets/images/rendang.jpg',
      'description':
          'Olahan daging sapi dengan rempah dan santan yang dimasak berjam-jam hingga kering.',
      'history':
          'Berasal dari Minangkabau, teknik merandang digunakan untuk mengawetkan daging.',
    },
    {
      'name': 'Nasi Goreng',
      'daerah': 'Jawa',
      'img': 'assets/images/nasi_goreng.jpg',
      'description': 'Nasi digoreng dengan kecap manis dan rempah.',
      'history': 'Adaptasi kuliner Tionghoa dengan cita rasa lokal Nusantara.',
    },
    {
      'name': 'Sate Madura',
      'daerah': 'Jawa & Madura',
      'img': 'assets/images/sate_madura.jpg',
      'description': 'Sate ayam dengan bumbu kacang manis.',
      'history': 'Resep dari para pelaut Madura.',
    },
    {
      'name': 'Soto Ayam',
      'daerah': 'Jawa Tengah',
      'img': 'assets/images/soto_ayam.jpg',
      'description': 'Sup ayam kuah kuning.',
      'history': 'Perpaduan budaya Jawa dan Tiongkok.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final displayedFavorites = _favoriteFoods
        .where(
          (food) =>
              food['name']!.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              food['daerah']!.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent, // Transparan agar batik tembus
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Favorit Saya',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- SEARCH BAR GLASSMORPHISM (SUPER MENONJOL) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: rustRed.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY: 20,
                    ), // Blur ditingkatkan
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        // Gradasi untuk efek pantulan cahaya kaca
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: textDark.withOpacity(0.7),
                          ),
                          hintText: 'Cari favorit...',
                          hintStyle: TextStyle(
                            color: textDark.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${displayedFavorites.length} makanan tersimpan',
                style: TextStyle(
                  fontSize: 12,
                  color: textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- GRID MAKANAN ---
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: displayedFavorites.length,
                itemBuilder: (context, index) =>
                    _buildGlassCard(displayedFavorites[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- KARTU MAKANAN GLASSMORPHISM (SUPER MENONJOL) ---
  Widget _buildGlassCard(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // Shadow di belakang kartu agar kaca melayang
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Blur dinaikkan
          child: Container(
            decoration: BoxDecoration(
              // Gradasi khas kaca premium
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailScreen(food: item),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              item['img']!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.white.withOpacity(0.2),
                                    child: const Center(
                                      child: Icon(
                                        Icons.restaurant,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite,
                                size: 16,
                                color: rustRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: textDark.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item['daerah']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textDark.withOpacity(0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
