import 'dart:ui'; // <-- Tambahan wajib untuk efek blur kaca (BackdropFilter)
import 'package:flutter/material.dart';
import 'food_detail_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // --- HELPER UNIVERSAL UNTUK EFEK KACA (GLASSMORPHISM) ---
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

  // --- HELPER KHUSUS UNTUK KACA TEMATIK MERAH (QUIZ BOX) ---
  Widget _buildRedGlassContainer({
    required Widget child,
    required BorderRadius borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA84A3B).withOpacity(0.15),
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
                  const Color(0xFFA84A3B).withOpacity(0.85),
                  const Color(0xFFA84A3B).withOpacity(0.55),
                ],
              ),
              borderRadius: borderRadius,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
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
    // --- PENGATURAN WARNA DARI FIGMA ---
    const Color textDark = Color(0xFF3E2723);
    const Color textLight = Color(0xFF8B7360);
    const Color rustRed = Color(0xFFA84A3B);

    return Scaffold(
      backgroundColor: Colors
          .transparent, // DIUBAH: Transparan agar background MainWrapper tembus!
      body: Stack(
        children: [
          // 1. BACKGROUND TEXTURE
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://images.unsplash.com/photo-1645699691860-3f9febbe2c4c?q=80&w=685&auto=format&fit=crop',
                height: 400,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          // 2. KONTEN UTAMA
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // --- HEADLINE ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rasa Asli\nIndonesia\ndalam Satu\nGenggaman',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                            height: 1.15,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Jelajahi kekayaan kuliner nusantara dari Sabang\nsampai Merauke',
                          style: TextStyle(
                            fontSize: 14,
                            color: textLight,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- SEARCH BAR (Diubah Jadi Kaca) ---
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
                            icon: Icon(Icons.search, color: textLight),
                            hintText: 'Cari rendang, gudeg, papeda...',
                            hintStyle: TextStyle(
                              color: textLight,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- SECTION 1: POPULER HARI INI ---
                  _buildSectionTitle(
                    Icons.trending_up,
                    'Populer Hari Ini',
                    textDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: _buildFoodGrid(
                      context,
                      [
                        {
                          'name': 'Rendang',
                          'daerah': 'Sumatera Barat',
                          'img':
                              'https://images.unsplash.com/photo-1620700668269-d3ad2a88f27e?q=80&w=687&auto=format&fit=crop',
                          'description':
                              'Masakan daging bercita rasa pedas yang menggunakan campuran berbagai bumbu dan rempah-rempah yang dimasak berjam-jam.',
                          'history':
                              'Rendang merupakan hidangan tradisional Minangkabau. Masakan ini telah menjadi warisan budaya tak benda Indonesia yang diakui UNESCO.',
                          'ingredients':
                              'Daging sapi, Santan kelapa, Cabai merah, Bawang merah, Lengkuas, Serai',
                          'taste_gurih': '5',
                          'taste_pedas': '4',
                          'taste_manis': '2',
                          'taste_asam': '1',
                          'serving':
                              'Disajikan dengan nasi putih hangat dan kerupuk.',
                          'culture':
                              'Sering disajikan pada acara adat Minangkabau, perayaan Idul Fitri, dan penyambutan tamu.',
                          'best_time': 'Makan siang atau makan malam',
                          'tradition': 'Upacara adat Minangkabau',
                        },
                        {
                          'name': 'Nasi Goreng',
                          'daerah': 'Jawa',
                          'img':
                              'https://images.unsplash.com/photo-1603133872878-684f208fb84b?q=80&w=1025&auto=format&fit=crop',
                          'description':
                              'Hidangan nasi yang digoreng dalam wajan menghasilkan rasa gurih manis khas, dicampur dengan bumbu rempah dan kecap.',
                          'history':
                              'Diadaptasi dari kuliner Tionghoa, Nasi Goreng versi Indonesia menjadi unik berkat penggunaan kecap manis dan bumbu lokal.',
                          'ingredients':
                              'Nasi putih, Kecap manis, Bawang merah, Bawang putih, Cabai, Telur',
                          'taste_gurih': '5',
                          'taste_pedas': '3',
                          'taste_manis': '4',
                          'taste_asam': '1',
                          'serving':
                              'Disajikan panas dengan telur mata sapi, kerupuk, dan acar mentimun.',
                          'culture':
                              'Sering disebut sebagai makanan rakyat karena kemudahannya ditemukan di kaki lima hingga restoran mewah.',
                          'best_time': 'Sarapan atau Makan malam',
                          'tradition': 'Menu jamuan santai keluarga',
                        },
                        {
                          'name': 'Sate',
                          'daerah': 'Jawa & Madura',
                          'img':
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Sate_ayam_madura.jpg/960px-Sate_ayam_madura.jpg',
                          'description':
                              'Potongan daging kecil yang ditusuk lidi bambu lalu dipanggang menggunakan bara arang kayu.',
                          'history':
                              'Diduga diciptakan oleh pedagang makanan jalanan di Jawa pada abad ke-19 yang terinspirasi dari kebab pedagang Arab/India.',
                          'ingredients':
                              'Daging ayam/kambing, Kacang tanah, Kecap manis, Bawang merah, Jeruk limau',
                          'taste_gurih': '4',
                          'taste_pedas': '2',
                          'taste_manis': '5',
                          'taste_asam': '1',
                          'serving':
                              'Disajikan panas dengan lontong atau nasi, disiram bumbu kacang.',
                          'culture':
                              'Menjadi ikon kuliner malam di banyak daerah di Indonesia.',
                          'best_time': 'Makan malam',
                          'tradition': 'Festival kuliner jalanan',
                        },
                        {
                          'name': 'Soto Ayam',
                          'daerah': 'Jawa Tengah',
                          'img':
                              'https://upload.wikimedia.org/wikipedia/id/1/15/Soto_Jepara.jpeg',
                          'description':
                              'Sup ayam berkuah kuning bening yang hangat dan menyegarkan, kaya akan rempah kunyit dan serai.',
                          'history':
                              'Merupakan perpaduan budaya lokal Jawa dengan tradisi kuliner Tiongkok (Caudo).',
                          'ingredients':
                              'Daging ayam, Kunyit, Serai, Bihun, Kol, Telur rebus',
                          'taste_gurih': '5',
                          'taste_pedas': '1',
                          'taste_manis': '1',
                          'taste_asam': '3',
                          'serving':
                              'Disajikan hangat dengan nasi putih, sate telur puyuh, perasan jeruk nipis dan sambal.',
                          'culture':
                              'Comfort food masyarakat Indonesia yang sering menjadi menu andalan sarapan pagi.',
                          'best_time': 'Sarapan atau Makan siang',
                          'tradition': 'Kuliner harian Nusantara',
                        },
                      ],
                      textDark,
                      textLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- SECTION 2: JELAJAH BERDASARKAN DAERAH ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jelajah Berdasarkan Daerah',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: rustRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRegionCard(
                    'Sumatera',
                    '128 Makanan',
                    'https://images.unsplash.com/photo-1573722496475-e045ca04ed57?q=80&w=1170&auto=format&fit=crop',
                  ),
                  _buildRegionCard(
                    'Jawa',
                    '245 Makanan',
                    'https://plus.unsplash.com/premium_photo-1700955004555-900a9733ee14?q=80&w=1170&auto=format&fit=crop',
                  ),
                  _buildRegionCard(
                    'Sulawesi',
                    '89 Makanan',
                    'https://images.unsplash.com/photo-1582426007790-f5a2e2392dd3?q=80&w=1074&auto=format&fit=crop',
                  ),
                  const SizedBox(height: 32),

                  // --- SECTION 3: PILIHAN EDITOR ---
                  _buildSectionTitle(
                    Icons.workspace_premium_outlined,
                    'Pilihan Editor',
                    textDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: _buildFoodGrid(
                      context,
                      [
                        {
                          'name': 'Coto Makassar',
                          'daerah': 'Sulawesi Selatan',
                          'img':
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Kuliner_Coto_Makassar.jpg/250px-Kuliner_Coto_Makassar.jpg',
                          'description':
                              'Sup daging dan jeroan sapi khas Makassar yang kaya rempah dengan kuah kental dari kacang tanah sangrai yang dihaluskan.',
                          'history':
                              'Berasal dari Kerajaan Gowa pada abad ke-16, hidangan ini mendapat pengaruh kuliner Tiongkok dan awalnya menjadi sajian istana.',
                          'ingredients':
                              'Daging sapi, Kacang tanah, Bawang merah, Serai, Lengkuas, Ketumbar',
                          'taste_gurih': '5',
                          'taste_pedas': '2',
                          'taste_manis': '1',
                          'taste_asam': '2',
                          'serving':
                              'Disajikan panas bersama ketupat atau burasa, ditambah perasan jeruk nipis dan sambal tauco.',
                          'culture':
                              'Sering dihidangkan pada acara adat, perayaan penting, dan momen kumpul keluarga di Sulawesi Selatan.',
                          'best_time': 'Sarapan atau Makan Siang',
                          'tradition': 'Perayaan Adat & Lebaran',
                        },
                        {
                          'name': 'Ayam Betutu',
                          'daerah': 'Bali',
                          'img':
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Ayam_Betutu.jpg/1920px-Ayam_Betutu.jpg',
                          'description':
                              'Hidangan ayam utuh yang dimasak perlahan dengan bumbu genep khas Bali yang super pedas dan kaya rempah, seringkali dibungkus daun pisang.',
                          'history':
                              'Hidangan legendaris dari Gianyar, Bali. Awalnya merupakan makanan suci untuk persembahan upacara keagamaan sebelum dipopulerkan.',
                          'ingredients':
                              'Ayam kampung, Bumbu Genep, Cabai rawit, Daun singkong, Serai, Kunyit',
                          'taste_gurih': '4',
                          'taste_pedas': '5',
                          'taste_manis': '1',
                          'taste_asam': '1',
                          'serving':
                              'Disajikan bersama nasi putih panas, sate lilit, sayur lawar, dan sambal matah.',
                          'culture':
                              'Memiliki nilai sakral yang tinggi dan merupakan simbol rasa syukur dalam berbagai upacara keagamaan Hindu di Bali.',
                          'best_time': 'Makan Siang atau Malam',
                          'tradition': 'Upacara Odalan & Galungan',
                        },
                      ],
                      textDark,
                      textLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- SECTION 4: CERITA DI BALIK RASA ---
                  _buildSectionTitle(
                    Icons.menu_book_rounded,
                    'Cerita di Balik Rasa',
                    textDark,
                  ),
                  const SizedBox(height: 16),
                  _buildArticleCard(
                    'Filosofi Dibalik Rendang: Lebih dari Sekedar Masakan',
                    'Rendang bukan hanya makanan, tetapi simbol kesabaran dan kehangatan...',
                    '5 menit baca',
                    'https://images.unsplash.com/photo-1620700668269-d3ad2a88f27e?q=80&w=687&auto=format&fit=crop',
                    textDark,
                    textLight,
                  ),
                  _buildArticleCard(
                    'Perjalanan Nasi Goreng: Dari Dapur Rakyat ke Meja Dunia',
                    'Bagaimana nasi goreng menjadi ikon kuliner Indonesia yang dikenal hingga...',
                    '7 menit baca',
                    'https://images.unsplash.com/photo-1603133872878-684f208fb84b?q=80&w=1025&auto=format&fit=crop',
                    textDark,
                    textLight,
                  ),
                  const SizedBox(height: 32),

                  // --- SECTION 5: REKOMENDASI UNTUK ANDA ---
                  _buildSectionTitle(
                    Icons.auto_awesome,
                    'Rekomendasi Untuk Anda',
                    textDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: _buildFoodGrid(
                      context,
                      [
                        {
                          'name': 'Mie Aceh',
                          'daerah': 'Aceh',
                          'img':
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Mie_Aceh.jpg/1280px-Mie_Aceh.jpg',
                          'description':
                              'Hidangan mi tebal bercita rasa pedas khas Aceh, disajikan dengan kuah kari kental yang kaya rempah.',
                          'history':
                              'Mencerminkan sejarah Aceh; kuah karinya dari pengaruh India, mi dari Tiongkok, dan daging kambing/sapi dari nilai keislaman.',
                          'ingredients':
                              'Mi kuning tebal, Daging sapi/seafood, Cabai, Kapulaga, Jintan, Bawang',
                          'taste_gurih': '5',
                          'taste_pedas': '5',
                          'taste_manis': '1',
                          'taste_asam': '1',
                          'serving':
                              'Disajikan panas dengan emping, irisan mentimun, dan perasan jeruk nipis.',
                          'culture':
                              'Sangat lekat dengan tradisi ngopi di kedai-kedai kopi Aceh tempat masyarakat berkumpul.',
                          'best_time': 'Makan siang atau malam',
                          'tradition': 'Budaya kedai kopi',
                        },
                        {
                          'name': 'Es Cendol',
                          'daerah': 'Jawa Barat',
                          'img':
                              'https://upload.wikimedia.org/wikipedia/commons/c/c2/Cendol_penang.jpg',
                          'description':
                              'Minuman es manis dengan butiran tepung beras hijau yang kenyal, disiram santan kelapa dan sirup gula aren.',
                          'history':
                              'Minuman tradisional Nusantara yang legendaris. Di Sunda dikenal dengan Cendol, di wilayah Jawa lain sering disebut Dawet.',
                          'ingredients':
                              'Tepung beras, Ekstrak daun pandan, Santan kelapa, Gula aren cair, Es serut',
                          'taste_gurih': '3',
                          'taste_pedas': '0',
                          'taste_manis': '5',
                          'taste_asam': '0',
                          'serving':
                              'Disajikan dingin dalam gelas tinggi dengan es serut di siang hari yang terik.',
                          'culture':
                              'Minuman pelepas dahaga yang sangat merakyat, mudah ditemukan di pasar hingga pinggir jalan.',
                          'best_time': 'Siang hari terik',
                          'tradition': 'Minuman pelepas dahaga',
                        },
                      ],
                      textDark,
                      textLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- SECTION 6: QUIZ KULINER (Diubah Jadi Kaca Merah) ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildRedGlassContainer(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Quiz Kuliner Hari Ini',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.extension,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Uji pengetahuan kuliner Anda!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),
                            MouseRegion(
                              cursor: SystemMouseCursors
                                  .click, // Efek kursor saat diarahkan ke tombol
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const QuizScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: rustRed,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Mulai Quiz',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }

  // =========================================================================
  // HELPER WIDGETS
  // =========================================================================
  Widget _buildSectionTitle(IconData icon, String title, Color textDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(icon, color: textDark, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  // DIUBAH JADI KARTU KACA: _buildFoodGrid
  Widget _buildFoodGrid(
    BuildContext context,
    List<Map<String, String>> items,
    Color textDark,
    Color textLight,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGlassContainer(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailScreen(food: item),
                  ),
                );
              },
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
                          child: Image.network(
                            item['img']!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              size: 16,
                              color: Colors.grey,
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
                              color: textLight,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item['daerah']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textLight,
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
        );
      },
    );
  }

  // DITAMBAHKAN BORDER KACA: _buildRegionCard
  Widget _buildRegionCard(String title, String subtitle, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
        // Aksen border tipis seperti kaca
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DIUBAH JADI KARTU KACA: _buildArticleCard
  Widget _buildArticleCard(
    String title,
    String desc,
    String time,
    String imgUrl,
    Color textDark,
    Color textLight,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: _buildGlassContainer(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 12,
                        color: textLight,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imgUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
