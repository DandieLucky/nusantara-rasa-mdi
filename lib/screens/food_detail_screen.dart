import 'package:flutter/material.dart';

class FoodDetailScreen extends StatelessWidget {
  final Map<String, String> food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    // --- DATABASE SEDERHANA UNTUK PROTOTIPE ---
    // Data akan otomatis berubah menyesuaikan makanan yang diklik!
    final Map<String, Map<String, dynamic>> foodDatabase = {
      'Nasi Goreng': {
        'desc':
            'Nasi goreng adalah hidangan nasi yang digoreng dalam wajan dengan campuran bumbu halus seperti bawang dan kecap manis, menghasilkan cita rasa gurih khas nusantara.',
        'history':
            'Meski mendapat pengaruh dari budaya kuliner Tionghoa, Nasi Goreng beradaptasi dengan lidah lokal Indonesia melalui penggunaan kecap manis dan rempah tradisional.',
        'ingredients': [
          'Nasi putih',
          'Kecap manis',
          'Bawang merah',
          'Bawang putih',
          'Cabai merah',
          'Telur ayam',
          'Garam & Merica',
          'Minyak goreng',
        ],
        'taste': {'Gurih': 5, 'Pedas': 3, 'Manis': 3, 'Asam': 1},
        'serving':
            'Disajikan panas dengan telur mata sapi, kerupuk, irisan tomat, dan mentimun segar.',
        'culture':
            'Mencerminkan keramahtamahan, Nasi Goreng sering disebut "makanan rakyat" yang mudah ditemukan dari kaki lima hingga restoran.',
        'best_time': 'Sarapan atau makan malam',
        'tradition': 'Sajian keluarga & santai',
      },
      'Rendang': {
        'desc':
            'Rendang adalah masakan daging bercita rasa pedas yang menggunakan campuran berbagai bumbu dan rempah-rempah. Masakan ini dihasilkan dari proses memasak berjam-jam.',
        'history':
            'Berasal dari Sumatera Barat dan merupakan hidangan tradisional Minangkabau. Masakan ini telah menjadi warisan budaya tak benda Indonesia yang diakui UNESCO.',
        'ingredients': [
          'Daging sapi',
          'Santan kelapa',
          'Cabai merah',
          'Bawang merah',
          'Bawang putih',
          'Lengkuas',
          'Serai',
          'Daun jeruk',
        ],
        'taste': {'Gurih': 5, 'Pedas': 4, 'Manis': 2, 'Asam': 1},
        'serving':
            'Disajikan hangat dengan nasi putih, daun singkong rebus, dan siraman kuah gulai.',
        'culture':
            'Sering disajikan pada acara-acara adat Minangkabau seperti upacara pernikahan, perayaan Lebaran, dan penyambutan tamu penting.',
        'best_time': 'Makan siang / malam',
        'tradition': 'Upacara adat Minangkabau',
      },
      'Sate': {
        'desc':
            'Sate adalah hidangan daging yang dipotong kecil, ditusuk dengan bambu, kemudian dipanggang menggunakan bara arang kayu dan disajikan dengan bumbu khas.',
        'history':
            'Diciptakan oleh pedagang makanan jalanan di Jawa pada awal abad ke-19, terinspirasi dari kebab khas Timur Tengah yang dibawa oleh pedagang Arab.',
        'ingredients': [
          'Daging ayam/sapi',
          'Kacang tanah',
          'Kecap manis',
          'Bawang merah',
          'Cabai rawit',
          'Jeruk nipis',
          'Tusuk sate',
          'Arang kayu',
        ],
        'taste': {'Gurih': 4, 'Pedas': 2, 'Manis': 4, 'Asam': 2},
        'serving':
            'Disajikan dengan lontong atau ketupat, siraman bumbu kacang pekat, dan taburan bawang goreng.',
        'culture':
            'Menjadi jajanan jalanan ikonik di Indonesia dan sering hadir sebagai menu wajib dalam perayaan pesta masyarakat.',
        'best_time': 'Makan malam santai',
        'tradition': 'Jajanan malam Nusantara',
      },
      // Data Default (Penyelamat jika makanan lain yang belum ada di database diklik)
      'default': {
        'desc':
            'Kuliner otentik nusantara yang kaya akan rempah dan mewakili tradisi turun-temurun dari daerah asalnya. Memiliki perpaduan rasa yang khas dan unik.',
        'history':
            'Hidangan ini telah diwariskan dari generasi ke generasi, menjadi bagian tak terpisahkan dari identitas budaya lokal dan kebanggaan masyarakat.',
        'ingredients': [
          'Bahan Utama',
          'Rempah lokal',
          'Garam & Gula',
          'Bawang merah',
          'Bawang putih',
          'Cabai',
          'Penyedap alami',
          'Minyak/Santan',
        ],
        'taste': {'Gurih': 4, 'Pedas': 3, 'Manis': 3, 'Asam': 2},
        'serving':
            'Disajikan hangat bersama pendamping pelengkap khas daerah asalnya.',
        'culture':
            'Merupakan simbol kebersamaan dan kekayaan hasil bumi masyarakat lokal dalam berbagai perayaan dan kehidupan sehari-hari.',
        'best_time': 'Kapan saja',
        'tradition': 'Kuliner tradisional lokal',
      },
    };

    // Ambil data berdasarkan nama makanan, kalau belum dicatat pakai data 'default'
    final String foodName = food['name'] ?? 'Unknown';
    final detailData = foodDatabase[foodName] ?? foodDatabase['default']!;

    // --- WARNA TEMA ---
    const Color bgCream = Color(0xFFFAF8F4);
    const Color textDark = Color(0xFF3E2723);
    const Color textLight = Color(0xFF8D6E63);
    const Color rustRed = Color(0xFFA84A3B);

    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: bgCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: textDark),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GAMBAR MAKANAN DINAMIS ---
            Image.network(
              food['img']!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER JUDUL & LOKASI DINAMIS ---
                  Text(
                    foodName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        food['daerah']!,
                        style: const TextStyle(fontSize: 14, color: textLight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- BUTTON CHIPS ---
                  Row(
                    children: [
                      _buildChip(Icons.people_outline, '98% Populer', rustRed),
                      const SizedBox(width: 12),
                      _buildChip(Icons.map_outlined, 'Lihat di Peta', rustRed),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- DESKRIPSI ---
                  _buildSectionTitle('Deskripsi', textDark),
                  const SizedBox(height: 8),
                  Text(
                    detailData['desc'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- SEJARAH ---
                  _buildSectionTitle('Sejarah', textDark),
                  const SizedBox(height: 8),
                  Text(
                    detailData['history'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- BAHAN UTAMA ---
                  _buildSectionTitle('Bahan Utama', textDark),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: (detailData['ingredients'] as List).length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EDE4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          detailData['ingredients'][index],
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // --- PROFIL RASA ---
                  _buildSectionTitle('Profil Rasa', textDark),
                  const SizedBox(height: 16),
                  _buildTasteBar(
                    'Gurih',
                    detailData['taste']['Gurih'],
                    rustRed,
                    textDark,
                  ),
                  _buildTasteBar(
                    'Pedas',
                    detailData['taste']['Pedas'],
                    rustRed,
                    textDark,
                  ),
                  _buildTasteBar(
                    'Manis',
                    detailData['taste']['Manis'],
                    rustRed,
                    textDark,
                  ),
                  _buildTasteBar(
                    'Asam',
                    detailData['taste']['Asam'],
                    rustRed,
                    textDark,
                  ),
                  const SizedBox(height: 32),

                  // --- CARA PENYAJIAN ---
                  _buildSectionTitle('Cara Penyajian', textDark),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EDE4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      detailData['serving'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: textLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- NILAI BUDAYA ---
                  _buildSectionTitle('Nilai Budaya', textDark),
                  const SizedBox(height: 8),
                  Text(
                    detailData['culture'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- BOTTOM CARDS ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          Icons.schedule,
                          'Cocok Dinikmati',
                          detailData['best_time'],
                          rustRed,
                          textDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          Icons.local_fire_department_outlined,
                          'Tradisi Terkait',
                          detailData['tradition'],
                          rustRed,
                          textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // HELPER WIDGETS
  // =========================================================================
  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildTasteBar(
    String label,
    int value,
    Color barColor,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                '$value/5',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 5,
              backgroundColor: Colors.grey.shade300,
              color: barColor,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
