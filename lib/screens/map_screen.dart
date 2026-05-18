import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  // --- FUNGSI UNTUK MEMBUKA GOOGLE MAPS ---
  Future<void> _bukaGoogleMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.co.id/maps/search/Restoran+Kuliner+Nusantara/',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Tidak dapat membuka peta');
    }
  }

  // --- HELPER UNTUK EFEK KACA (GLASSMORPHISM) ---
  Widget _buildGlassContainer({
    required Widget child,
    required BorderRadius borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              borderRadius: borderRadius,
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- PENGATURAN WARNA ---
    const Color textDarkBrown = Color(0xFF3E2723);
    const Color textLightBrown = Color(0xFF8D6E63);
    const Color rustRed = Color(0xFFA84A3B);

    // Data Region untuk Grid
    final List<Map<String, dynamic>> regions = [
      {
        'name': 'Sumatera',
        'count': '128 Makanan',
        'color': const Color(0xFF8B322C),
      },
      {
        'name': 'Jawa',
        'count': '245 Makanan',
        'color': const Color(0xFFD9A05B),
      },
      {
        'name': 'Kalimantan',
        'count': '76 Makanan',
        'color': const Color(0xFF5A7D59),
      },
      {
        'name': 'Sulawesi',
        'count': '89 Makanan',
        'color': const Color(0xFF8B322C),
      },
      {
        'name': 'Bali & Nusa\nTenggara',
        'count': '54 Makanan',
        'color': const Color(0xFFD9A05B),
      },
      {
        'name': 'Papua &\nMaluku',
        'count': '42 Makanan',
        'color': const Color(0xFF5A7D59),
      },
    ];

    // Data Makanan Populer
    final List<Map<String, String>> popularFoods = [
      {
        'name': 'Rendang',
        'daerah': 'Sumatera Barat',
        'img':
            'https://images.unsplash.com/photo-1620700668269-d3ad2a88f27e?w=400',
      },
      {
        'name': 'Gudeg',
        'daerah': 'Jawa Tengah',
        'img':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Nasi_Gudeg.jpg/1280px-Nasi_Gudeg.jpg',
      },
      {
        'name': 'Coto Makassar',
        'daerah': 'Sulawesi Selatan',
        'img':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Kuliner_Coto_Makassar.jpg/250px-Kuliner_Coto_Makassar.jpg',
      },
      {
        'name': 'Ayam Betutu',
        'daerah': 'Bali',
        'img':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Ayam_Betutu.jpg/1920px-Ayam_Betutu.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- HEADER ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Peta Kuliner Nusantara',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: textDarkBrown,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- SEARCH BAR ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildGlassContainer(
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: textLightBrown),
                        hintText: 'Cari daerah...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- SECTION 1: JELAJAHI INDONESIA ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildGlassContainer(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: double.infinity, // Memastikan kontainer melar full
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: rustRed,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Jelajahi Indonesia',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textDarkBrown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Temukan kekayaan kuliner dari berbagai\npenjuru nusantara',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: textLightBrown,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.6,
                              ),
                          itemCount: regions.length,
                          itemBuilder: (context, index) {
                            final region = regions[index];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: region['color'],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    region['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: textDarkBrown,
                                      height: 1.2,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    region['count'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: textLightBrown,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- SECTION 2: POPULER DI SETIAP DAERAH ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Populer di Setiap Daerah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDarkBrown,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: popularFoods.length,
                itemBuilder: (context, index) {
                  final food = popularFoods[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildGlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity, // Memastikan melar full
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                food['img']!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food['name']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textDarkBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: textLightBrown,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        food['daerah']!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: textLightBrown,
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
                  );
                },
              ),
              const SizedBox(height: 24),

              // --- SECTION 3: PETA INTERAKTIF ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildGlassContainer(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: double.infinity, // <-- INI DIA KUNCI JAWABANNYA!
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: rustRed.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.map_outlined,
                            color: rustRed,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Peta Interaktif',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textDarkBrown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Jelajahi kuliner Indonesia dengan peta\ninteraktif',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: textLightBrown,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- TOMBOL BUKA PETA LENGKAP ---
                        ElevatedButton(
                          onPressed: _bukaGoogleMaps,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: rustRed,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Buka Peta Lengkap',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
