import 'dart:ui';
import 'package:flutter/material.dart';
import 'food_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Color textDark = const Color(0xFF3E2723);
  final Color textLight = const Color(0xFF8B7360);
  final Color rustRed = const Color(0xFFA84A3B);

  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  String _selectedSort = 'A-Z';
  String _selectedRegion = 'Semua Daerah';

  final List<String> _categories = [
    'Semua',
    'Makanan Berat',
    'Camilan',
    'Minuman',
  ];
  final List<String> _regionOptions = [
    'Semua Daerah',
    'Sumatera',
    'Jawa',
    'Sulawesi',
    'Bali',
    'Nusa Tenggara',
    'Papua',
  ];

  // --- DATABASE 60 MAKANAN NUSANTARA LENGKAP ---
  final List<Map<String, String>> _allFoods = [
    // ================= SUMATERA (10) =================
    {
      'name': 'Rendang',
      'daerah': 'Sumatera',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/rendang.jpg',
      'description':
          'Olahan daging sapi dengan rempah dan santan yang dimasak berjam-jam hingga kering.',
      'history':
          'Berasal dari Minangkabau, teknik merandang digunakan untuk mengawetkan daging.',
      'ingredients': 'Daging Sapi, Santan, Cabai, Serai, Lengkuas',
      'taste_gurih': '5',
      'taste_pedas': '4',
      'taste_manis': '2',
      'taste_asam': '1',
      'serving': 'Dengan nasi hangat.',
      'culture': 'Simbol kebanggaan adat.',
      'best_time': 'Makan siang',
      'tradition': 'Upacara Adat',
    },
    {
      'name': 'Pempek',
      'daerah': 'Sumatera',
      'kategori': 'Camilan',
      'img': 'assets/images/pempek.jpg',
      'description': 'Olahan ikan tenggiri dan sagu dengan kuah cuko pedas.',
      'history': 'Akulturasi budaya lokal Palembang dan Tionghoa.',
      'ingredients': 'Ikan, Sagu, Gula Batok, Cabai',
      'taste_gurih': '4',
      'taste_pedas': '4',
      'taste_manis': '4',
      'taste_asam': '4',
      'serving': 'Digoreng garing.',
      'culture': 'Oleh-oleh khas Palembang.',
      'best_time': 'Sore hari',
      'tradition': 'Camilan harian',
    },
    {
      'name': 'Mie Aceh',
      'daerah': 'Sumatera',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/mie_aceh.jpg',
      'description': 'Mie tebal dengan bumbu kari pedas.',
      'history': 'Pengaruh kuliner India, Tiongkok, dan Arab di Aceh.',
      'ingredients': 'Mie kuning, Daging/Seafood, Rempah kari',
      'taste_gurih': '5',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Dengan emping dan acar.',
      'culture': 'Teman nongkrong di kedai kopi.',
      'best_time': 'Malam hari',
      'tradition': 'Budaya warung kopi',
    },
    {
      'name': 'Sate Padang',
      'daerah': 'Sumatera',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/sate_padang.jpg',
      'description': 'Sate daging sapi dengan kuah kental kuning pedas.',
      'history': 'Khas Minang dengan kuah dari tepung beras.',
      'ingredients': 'Daging sapi, Tepung beras, Rempah',
      'taste_gurih': '5',
      'taste_pedas': '4',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Dengan ketupat.',
      'culture': 'Sajian pesta adat.',
      'best_time': 'Malam hari',
      'tradition': 'Pasar malam',
    },
    {
      'name': 'Soto Medan',
      'daerah': 'Sumatera',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/soto_medan.jpg',
      'description': 'Soto berkuah santan kuning kehijauan.',
      'history': 'Khas kota Medan yang kaya rempah.',
      'ingredients': 'Ayam/Sapi, Santan, Kapulaga',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '1',
      'taste_asam': '2',
      'serving': 'Dengan perkedel.',
      'culture': 'Sarapan pagi warga Medan.',
      'best_time': 'Pagi hari',
      'tradition': 'Sarapan keluarga',
    },
    {
      'name': 'Bika Ambon',
      'daerah': 'Sumatera',
      'kategori': 'Camilan',
      'img': 'assets/images/bika_ambon.jpg',
      'description': 'Kue kuning bersarang dengan aroma daun jeruk.',
      'history':
          'Meskipun namanya Ambon, kue ini asli dari Medan (Jalan Ambon).',
      'ingredients': 'Tepung tapioka, Telur, Gula, Nira',
      'taste_gurih': '1',
      'taste_pedas': '0',
      'taste_manis': '5',
      'taste_asam': '0',
      'serving': 'Dipotong kotak.',
      'culture': 'Oleh-oleh wajib.',
      'best_time': 'Sore hari',
      'tradition': 'Hantaran',
    },
    {
      'name': 'Dendeng Batokok',
      'daerah': 'Sumatera',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/dendeng_batokok.jpg',
      'description':
          'Daging sapi yang dipukul (batokok) hingga pipih lalu digoreng.',
      'history': 'Teknik memukul daging agar bumbu cepat meresap.',
      'ingredients': 'Daging sapi, Cabai hijau/merah',
      'taste_gurih': '5',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Bersama nasi.',
      'culture': 'Sajian harian rumah makan Padang.',
      'best_time': 'Makan siang',
      'tradition': 'Menu wajib',
    },
    {
      'name': 'Ayam Pop',
      'daerah': 'Sumatera',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/ayam_pop.jpg',
      'description': 'Ayam rebus pucat yang sangat gurih.',
      'history':
          'Diciptakan oleh salah satu restoran legendaris di Bukittinggi.',
      'ingredients': 'Ayam kampung, Air kelapa',
      'taste_gurih': '5',
      'taste_pedas': '1',
      'taste_manis': '2',
      'taste_asam': '1',
      'serving': 'Dicocol sambal tomat.',
      'culture': 'Favorit di restoran Padang.',
      'best_time': 'Makan siang',
      'tradition': 'Jamuan',
    },
    {
      'name': 'Teh Talua',
      'daerah': 'Sumatera',
      'kategori': 'Minuman',
      'img': 'assets/images/teh_talua.jpg',
      'description': 'Minuman teh dicampur kuning telur kocok.',
      'history': 'Minuman penambah stamina khas pria Minang.',
      'ingredients': 'Teh, Kuning telur, Gula, Jeruk nipis',
      'taste_gurih': '3',
      'taste_pedas': '0',
      'taste_manis': '4',
      'taste_asam': '1',
      'serving': 'Panas-panas.',
      'culture': 'Diminum pagi/malam hari di lapau.',
      'best_time': 'Pagi/Malam',
      'tradition': 'Nongkrong lapau',
    },
    {
      'name': 'Gulai Tunjang',
      'daerah': 'Sumatera',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/gulai_tunjang.jpg',
      'description': 'Gulai kikil sapi kuah santan.',
      'history': 'Pemanfaatan seluruh bagian sapi dalam kuliner Minang.',
      'ingredients': 'Kikil sapi, Santan kental, Kunyit',
      'taste_gurih': '5',
      'taste_pedas': '3',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Dengan nasi panas.',
      'culture': 'Menu elit di rumah makan Padang.',
      'best_time': 'Makan siang',
      'tradition': 'Pesta',
    },

    // ================= JAWA (10) =================
    {
      'name': 'Nasi Goreng',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/nasi_goreng.jpg',
      'description': 'Nasi digoreng dengan kecap manis dan rempah.',
      'history': 'Adaptasi kuliner Tionghoa dengan cita rasa lokal Nusantara.',
      'ingredients': 'Nasi, Kecap, Telur',
      'taste_gurih': '5',
      'taste_pedas': '3',
      'taste_manis': '4',
      'taste_asam': '1',
      'serving': 'Dengan kerupuk dan acar.',
      'culture': 'Makanan nasional.',
      'best_time': 'Malam hari',
      'tradition': 'Kuliner harian',
    },
    {
      'name': 'Soto Ayam',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/soto_ayam.jpg',
      'description': 'Sup ayam kuah kuning.',
      'history': 'Perpaduan budaya Jawa dan Tiongkok (Caudo).',
      'ingredients': 'Ayam, Kunyit, Soun',
      'taste_gurih': '5',
      'taste_pedas': '1',
      'taste_manis': '1',
      'taste_asam': '2',
      'serving': 'Ditambah jeruk nipis.',
      'culture': 'Comfort food.',
      'best_time': 'Pagi hari',
      'tradition': 'Sarapan',
    },
    {
      'name': 'Gudeg',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/gudeg.jpg',
      'description': 'Sayur nangka muda manis yang dimasak lama.',
      'history': 'Makanan khas Jogja sejak abad 16.',
      'ingredients': 'Nangka muda, Gula aren, Santan',
      'taste_gurih': '3',
      'taste_pedas': '1',
      'taste_manis': '5',
      'taste_asam': '0',
      'serving': 'Dengan krecek pedas.',
      'culture': 'Simbol kelembutan budaya Jawa.',
      'best_time': 'Makan siang',
      'tradition': 'Hidangan keraton',
    },
    {
      'name': 'Rawon',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/rawon.jpg',
      'description': 'Sup daging berkuah hitam legam.',
      'history': 'Telah ada sejak era Kerajaan Majapahit.',
      'ingredients': 'Daging sapi, Kluwek',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '2',
      'taste_asam': '1',
      'serving': 'Dengan telur asin dan tauge.',
      'culture': 'Makanan kebanggaan Jawa Timur.',
      'best_time': 'Makan siang',
      'tradition': 'Acara hajatan',
    },
    {
      'name': 'Es Cendol',
      'daerah': 'Jawa',
      'kategori': 'Minuman',
      'img': 'assets/images/es_cendol.jpg',
      'description': 'Minuman manis dengan buliran tepung beras hijau.',
      'history': 'Minuman tradisional masyarakat Sunda.',
      'ingredients': 'Tepung beras, Santan, Gula aren',
      'taste_gurih': '2',
      'taste_pedas': '0',
      'taste_manis': '5',
      'taste_asam': '0',
      'serving': 'Dengan es serut.',
      'culture': 'Pelepas dahaga rakyat.',
      'best_time': 'Siang hari',
      'tradition': 'Minuman pasar',
    },
    {
      'name': 'Sate Madura',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/sate_madura.jpg',
      'description': 'Sate ayam dengan bumbu kacang manis.',
      'history': 'Resep dari para pelaut Madura.',
      'ingredients': 'Daging ayam, Kacang tanah, Kecap',
      'taste_gurih': '4',
      'taste_pedas': '2',
      'taste_manis': '5',
      'taste_asam': '1',
      'serving': 'Dengan lontong.',
      'culture': 'Dijajakan malam hari.',
      'best_time': 'Malam hari',
      'tradition': 'Kuliner malam',
    },
    {
      'name': 'Tongseng',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/tongseng.jpg',
      'description': 'Gulai kambing dengan tambahan kecap dan sayur kol.',
      'history': 'Sajian khas dari Solo.',
      'ingredients': 'Daging kambing, Kol, Kecap',
      'taste_gurih': '5',
      'taste_pedas': '3',
      'taste_manis': '4',
      'taste_asam': '1',
      'serving': 'Disajikan panas-panas.',
      'culture': 'Penghangat tubuh.',
      'best_time': 'Malam hari',
      'tradition': 'Warung tenda',
    },
    {
      'name': 'Pecel Madiun',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/pecel_madiun.jpg',
      'description': 'Sayuran rebus yang disiram bumbu kacang pedas manis.',
      'history': 'Makanan sehat sejak zaman dulu.',
      'ingredients': 'Sayuran, Kacang tanah, Cabai',
      'taste_gurih': '4',
      'taste_pedas': '4',
      'taste_manis': '3',
      'taste_asam': '1',
      'serving': 'Dengan peyek kacang.',
      'culture': 'Sarapan khas Jawa Timur.',
      'best_time': 'Pagi hari',
      'tradition': 'Sarapan sehat',
    },
    {
      'name': 'Rujak Cingur',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/rujak_cingur.jpg',
      'description': 'Salad lokal dengan potongan hidung sapi (cingur).',
      'history': 'Asli Surabaya, Jawa Timur.',
      'ingredients': 'Cingur sapi, Sayuran, Petis',
      'taste_gurih': '4',
      'taste_pedas': '3',
      'taste_manis': '3',
      'taste_asam': '2',
      'serving': 'Disajikan segar.',
      'culture': 'Makanan unik khas Suroboyo.',
      'best_time': 'Siang hari',
      'tradition': 'Makan siang',
    },
    {
      'name': 'Nasi Liwet',
      'daerah': 'Jawa',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/nasi_liwet.jpg',
      'description': 'Nasi gurih masak santan khas Solo.',
      'history': 'Cara masak nasi agar lebih lezat dan awet.',
      'ingredients': 'Nasi, Santan, Ayam suwir',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '2',
      'taste_asam': '1',
      'serving': 'Dihidangkan di pincuk daun pisang.',
      'culture': 'Sering disajikan di acara kumpul.',
      'best_time': 'Pagi/Malam',
      'tradition': 'Acara bancakan',
    },

    // ================= SULAWESI (10) =================
    {
      'name': 'Coto Makassar',
      'daerah': 'Sulawesi',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/coto_makassar.jpg',
      'description': 'Sup daging/jeroan sapi dengan bumbu rempah kacang.',
      'history': 'Diciptakan di era Kerajaan Gowa.',
      'ingredients': 'Sapi, Kacang tanah, Rempah',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '1',
      'taste_asam': '2',
      'serving': 'Bersama ketupat/burasa.',
      'culture': 'Mempersatukan warga saat Idul Fitri.',
      'best_time': 'Pagi/Siang',
      'tradition': 'Perayaan',
    },
    {
      'name': 'Es Pisang Ijo',
      'daerah': 'Sulawesi',
      'kategori': 'Minuman',
      'img': 'assets/images/es_pisang_ijo.jpg',
      'description': 'Pisang balut adonan hijau dengan bubur sumsum dan sirup.',
      'history': 'Kudapan turun-temurun Suku Bugis-Makassar.',
      'ingredients': 'Pisang, Tepung beras, Sirup merah',
      'taste_gurih': '2',
      'taste_pedas': '0',
      'taste_manis': '5',
      'taste_asam': '0',
      'serving': 'Dengan es serut.',
      'culture': 'Takjil Ramadhan terpopuler.',
      'best_time': 'Sore hari',
      'tradition': 'Buka puasa',
    },
    {
      'name': 'Sop Saudara',
      'daerah': 'Sulawesi',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/sop_saudara.jpg',
      'description': 'Sop daging sapi dengan tambahan soun dan perkedel.',
      'history': 'Berasal dari Pangkep, Sulawesi Selatan.',
      'ingredients': 'Daging sapi, Soun, Telur rebus',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Dimakan dengan nasi dan ikan bakar.',
      'culture': 'Simbol persaudaraan.',
      'best_time': 'Makan siang',
      'tradition': 'Makan bersama',
    },
    {
      'name': 'Pallubasa',
      'daerah': 'Sulawesi',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/pallubasa.jpg',
      'description':
          'Mirip coto tapi kuahnya memakai kelapa sangrai dan kuning telur mentah.',
      'history': 'Dulu makanan para pekerja kerajaan.',
      'ingredients': 'Daging sapi, Kelapa sangrai, Kuning telur',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '2',
      'taste_asam': '1',
      'serving': 'Telur diaduk panas-panas.',
      'culture': 'Sajian penuh energi.',
      'best_time': 'Siang hari',
      'tradition': 'Makan siang',
    },
    {
      'name': 'Kapurung',
      'daerah': 'Sulawesi',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/kapurung.jpg',
      'description': 'Bubur sagu dicampur kuah sayur dan ikan/ayam.',
      'history': 'Khas dari Luwu, Palopo.',
      'ingredients': 'Sagu, Sayuran, Ikan/Ayam',
      'taste_gurih': '4',
      'taste_pedas': '3',
      'taste_manis': '1',
      'taste_asam': '3',
      'serving': 'Disajikan hangat.',
      'culture': 'Makanan sehat berkuah segar.',
      'best_time': 'Makan siang',
      'tradition': 'Makanan rumahan',
    },
    {
      'name': 'Ikan Bakar Rica',
      'daerah': 'Sulawesi',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/ikan_bakar_rica.jpg',
      'description': 'Ikan laut bakar dengan sambal rica-rica super pedas.',
      'history': 'Ciri khas kuliner Minahasa, Manado.',
      'ingredients': 'Ikan, Cabai rawit, Jahe, Jeruk nipis',
      'taste_gurih': '4',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '3',
      'serving': 'Dengan nasi dan kangkung.',
      'culture': 'Kecintaan warga Manado pada rasa pedas.',
      'best_time': 'Makan siang',
      'tradition': 'Pesta seafood',
    },
    {
      'name': 'Woku Belanga',
      'daerah': 'Sulawesi',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/woku_belanga.jpg',
      'description':
          'Ayam/ikan yang dimasak di kuali tanah liat dengan bumbu kuning melimpah.',
      'history': 'Metode masak leluhur Minahasa.',
      'ingredients': 'Ayam/Ikan, Kemangi, Kunyit, Daun jeruk',
      'taste_gurih': '5',
      'taste_pedas': '4',
      'taste_manis': '1',
      'taste_asam': '2',
      'serving': 'Aroma kemanginya sangat harum.',
      'culture': 'Sajian acara spesial.',
      'best_time': 'Makan siang',
      'tradition': 'Acara adat',
    },
    {
      'name': 'Nasu Palekko',
      'daerah': 'Sulawesi',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/nasu_palekko.jpg',
      'description': 'Bebek/ayam potong kecil yang dimasak super pedas.',
      'history': 'Sajian khas suku Bugis dari Sidrap.',
      'ingredients': 'Bebek, Cabai, Asam jawa',
      'taste_gurih': '4',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '2',
      'serving': 'Kuah kentalnya dituang ke nasi.',
      'culture': 'Menguji ketahanan pedas.',
      'best_time': 'Siang/Malam',
      'tradition': 'Pesta kumpul',
    },
    {
      'name': 'Barongko',
      'daerah': 'Sulawesi',
      'kategori': 'Camilan',
      'img': 'assets/images/barongko.jpg',
      'description':
          'Kue basah dari pisang yang dihaluskan, dikukus dalam daun pisang.',
      'history': 'Dulu hanya disajikan untuk raja-raja Bugis.',
      'ingredients': 'Pisang, Telur, Santan',
      'taste_gurih': '2',
      'taste_pedas': '0',
      'taste_manis': '4',
      'taste_asam': '0',
      'serving': 'Enak dinikmati dingin.',
      'culture': 'Kue mewah acara pernikahan.',
      'best_time': 'Sore hari',
      'tradition': 'Pernikahan adat',
    },
    {
      'name': 'Sarabba',
      'daerah': 'Sulawesi',
      'kategori': 'Minuman',
      'img': 'assets/images/sarabba.jpg',
      'description':
          'Minuman penghangat tubuh dari jahe, gula aren, dan santan.',
      'history': 'Jamu tradisional ala Makassar.',
      'ingredients': 'Jahe, Gula aren, Santan, Merica',
      'taste_gurih': '2',
      'taste_pedas': '2',
      'taste_manis': '4',
      'taste_asam': '0',
      'serving': 'Diminum panas-panas.',
      'culture': 'Cocok saat cuaca dingin.',
      'best_time': 'Malam hari',
      'tradition': 'Nongkrong malam',
    },

    // ================= BALI (10) =================
    {
      'name': 'Ayam Betutu',
      'daerah': 'Bali',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/ayam_betutu.jpg',
      'description': 'Ayam rebus perlahan dengan bumbu Base Genep pedas.',
      'history': 'Aslinya makanan suci untuk persembahan dewa.',
      'ingredients': 'Ayam, Base genep, Serai',
      'taste_gurih': '4',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Disajikan utuh.',
      'culture': 'Nilai spiritual tinggi.',
      'best_time': 'Makan siang',
      'tradition': 'Upacara keagamaan',
    },
    {
      'name': 'Sate Lilit',
      'daerah': 'Bali',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/sate_lilit.jpg',
      'description': 'Daging giling yang dililitkan pada batang serai.',
      'history': 'Lilitan melambangkan masyarakat Bali yang bersatu.',
      'ingredients': 'Daging Ikan/Ayam, Kelapa parut, Serai',
      'taste_gurih': '5',
      'taste_pedas': '3',
      'taste_manis': '2',
      'taste_asam': '1',
      'serving': 'Tanpa bumbu kacang.',
      'culture': 'Sajian khas wajib di Bali.',
      'best_time': 'Makan siang',
      'tradition': 'Sajian harian',
    },
    {
      'name': 'Nasi Jinggo',
      'daerah': 'Bali',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/nasi_jinggo.jpg',
      'description': 'Nasi bungkus porsi kecil khas Bali.',
      'history': 'Mirip nasi kucing, populer sejak era 90-an.',
      'ingredients': 'Nasi, Ayam suwir, Tempe, Sambal',
      'taste_gurih': '4',
      'taste_pedas': '4',
      'taste_manis': '2',
      'taste_asam': '1',
      'serving': 'Dibungkus daun pisang.',
      'culture': 'Penyelamat lapar malam hari.',
      'best_time': 'Malam hari',
      'tradition': 'Street food',
    },
    {
      'name': 'Lawar',
      'daerah': 'Bali',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/lawar.jpg',
      'description': 'Campuran sayur dan daging cincang dengan kelapa.',
      'history': 'Simbol keseimbangan elemen di Bali.',
      'ingredients': 'Kacang panjang, Kelapa, Daging',
      'taste_gurih': '5',
      'taste_pedas': '3',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Pendamping nasi putih.',
      'culture': 'Dibuat bersama-sama menjelang upacara.',
      'best_time': 'Makan siang',
      'tradition': 'Gotong royong',
    },
    {
      'name': 'Tipat Cantok',
      'daerah': 'Bali',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/tipat_cantok.jpg',
      'description': 'Ketupat dan sayuran rebus dengan bumbu kacang.',
      'history': 'Mirip gado-gado versi Pulau Dewata.',
      'ingredients': 'Ketupat, Sayur, Kacang tanah, Terasi',
      'taste_gurih': '4',
      'taste_pedas': '3',
      'taste_manis': '3',
      'taste_asam': '1',
      'serving': 'Dihaluskan di cobek batu.',
      'culture': 'Menu vegetarian ramah turis.',
      'best_time': 'Siang hari',
      'tradition': 'Makan siang',
    },
    {
      'name': 'Rujak Kuah Pindang',
      'daerah': 'Bali',
      'kategori': 'Camilan',
      'img': 'assets/images/rujak_kuah_pindang.jpg',
      'description': 'Rujak buah dengan siraman kaldu ikan (pindang) pedas.',
      'history': 'Cara orang pesisir Bali menikmati rujak.',
      'ingredients': 'Buah segar, Kaldu ikan, Cabai',
      'taste_gurih': '4',
      'taste_pedas': '4',
      'taste_manis': '2',
      'taste_asam': '3',
      'serving': 'Disajikan dingin segar.',
      'culture': 'Rasa unik amis, pedas, dan segar.',
      'best_time': 'Siang hari',
      'tradition': 'Camilan pantai',
    },
    {
      'name': 'Serombotan',
      'daerah': 'Bali',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/serombotan.jpg',
      'description': 'Sayuran khas Klungkung dengan bumbu kelapa pedas.',
      'history': 'Sayuran tradisional Bali kuno.',
      'ingredients': 'Kangkung, Bayam, Bumbu kelapa',
      'taste_gurih': '4',
      'taste_pedas': '4',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Mirip urap.',
      'culture': 'Menu sehat masyarakat desa.',
      'best_time': 'Makan siang',
      'tradition': 'Lauk harian',
    },
    {
      'name': 'Jaja Klepon',
      'daerah': 'Bali',
      'kategori': 'Camilan',
      'img': 'assets/images/jaja_klepon.jpg',
      'description': 'Bola-bola hijau isi gula merah cair khas Gianyar.',
      'history': 'Jajanan pasar kuno yang melambangkan kesederhanaan.',
      'ingredients': 'Tepung ketan, Gula merah, Kelapa parut',
      'taste_gurih': '2',
      'taste_pedas': '0',
      'taste_manis': '5',
      'taste_asam': '0',
      'serving': 'Meledak di mulut saat digigit.',
      'culture': 'Pencuci mulut tradisional.',
      'best_time': 'Pagi/Sore',
      'tradition': 'Pasar tradisional',
    },
    {
      'name': 'Bubur Mengguh',
      'daerah': 'Bali',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/bubur_mengguh.jpg',
      'description': 'Bubur ayam khas Buleleng dengan kuah kental ayam suwir.',
      'history': 'Sajian khusus saat upacara adat di Bali Utara.',
      'ingredients': 'Beras, Ayam, Kacang panjang, Santan',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Sangat mengenyangkan.',
      'culture': 'Dimakan ramerame.',
      'best_time': 'Pagi hari',
      'tradition': 'Upacara adat',
    },
    {
      'name': 'Bebek Betutu',
      'daerah': 'Bali',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/bebek_betutu.jpg',
      'description':
          'Versi bebek dari ayam betutu, dimasak lebih lama agar empuk.',
      'history': 'Bebek adalah hewan berharga untuk sajian agung.',
      'ingredients': 'Bebek utuh, Base genep',
      'taste_gurih': '5',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Tekstur dagingnya sangat lembut.',
      'culture': 'Makanan raja-raja Bali.',
      'best_time': 'Makan malam',
      'tradition': 'Pesta besar',
    },

    // ================= NUSA TENGGARA (10) =================
    {
      'name': 'Ayam Taliwang',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/ayam_taliwang.jpg',
      'description': 'Ayam kampung bakar dengan cabai dan terasi super pedas.',
      'history': 'Khas dari Lombok, dulunya bekal perang kerajaan.',
      'ingredients': 'Ayam, Cabai, Terasi Lombok',
      'taste_gurih': '4',
      'taste_pedas': '5',
      'taste_manis': '2',
      'taste_asam': '2',
      'serving': 'Wajib dengan plecing kangkung.',
      'culture': 'Ikon kuliner Lombok.',
      'best_time': 'Makan siang',
      'tradition': 'Jamuan tamu',
    },
    {
      'name': 'Plecing Kangkung',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/plecing_kangkung.jpg',
      'description':
          'Kangkung air rebus yang disiram sambal tomat terasi segar.',
      'history': 'Lauk wajib pendamping semua masakan Lombok.',
      'ingredients': 'Kangkung, Sambal tomat terasi',
      'taste_gurih': '4',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '3',
      'serving': 'Disajikan dingin/suhu ruang.',
      'culture': 'Sangat segar dan pedas.',
      'best_time': 'Makan siang',
      'tradition': 'Pelengkap',
    },
    {
      'name': 'Se\'i Sapi',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/sei_sapi.jpg',
      'description': 'Daging sapi yang diasap berjam-jam dengan kayu kosambi.',
      'history': 'Teknik pengawetan daging khas Kupang, NTT.',
      'ingredients': 'Daging sapi, Garam, Rempah',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Diiris tipis, ditemani sambal lu\'at.',
      'culture': 'Kini populer di seluruh Indonesia.',
      'best_time': 'Makan siang',
      'tradition': 'Oleh-oleh NTT',
    },
    {
      'name': 'Sate Bulayak',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/sate_bulayak.jpg',
      'description':
          'Sate sapi bumbu santan dengan lontong daun kelapa (bulayak).',
      'history': 'Sajian khas masyarakat Sasak di Lombok.',
      'ingredients': 'Daging sapi, Santan, Lontong bulayak',
      'taste_gurih': '5',
      'taste_pedas': '3',
      'taste_manis': '2',
      'taste_asam': '1',
      'serving': 'Cara makannya unik.',
      'culture': 'Dijual di pinggir pantai.',
      'best_time': 'Sore hari',
      'tradition': 'Wisata kuliner',
    },
    {
      'name': 'Sate Rembiga',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/sate_rembiga.jpg',
      'description': 'Sate sapi tanpa bumbu kacang, berbumbu manis pedas.',
      'history': 'Berasal dari desa Rembiga, Lombok.',
      'ingredients': 'Daging sapi, Gula merah, Cabai',
      'taste_gurih': '4',
      'taste_pedas': '4',
      'taste_manis': '4',
      'taste_asam': '1',
      'serving': 'Disajikan langsung.',
      'culture': 'Cita rasa pedas manis yang khas.',
      'best_time': 'Malam hari',
      'tradition': 'Makan malam',
    },
    {
      'name': 'Catemak Jagung',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Camilan',
      'img': 'assets/images/catemak_jagung.jpg',
      'description': 'Bubur gurih asin dari jagung, kacang hijau, dan labu.',
      'history': 'Makanan pokok pengganti beras di NTT.',
      'ingredients': 'Jagung, Kacang hijau, Labu',
      'taste_gurih': '4',
      'taste_pedas': '1',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Mengenyangkan.',
      'culture': 'Melambangkan hasil bumi NTT.',
      'best_time': 'Siang hari',
      'tradition': 'Makanan pokok',
    },
    {
      'name': 'Jagung Bose',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/jagung_bose.jpg',
      'description': 'Jagung pipil rebus santan dengan kacang merah.',
      'history': 'Sajian tradisional yang lambat lambat makin langka.',
      'ingredients': 'Jagung putih, Santan, Kacang merah',
      'taste_gurih': '4',
      'taste_pedas': '0',
      'taste_manis': '2',
      'taste_asam': '0',
      'serving': 'Lauk pauk NTT.',
      'culture': 'Makanan hangat keluarga.',
      'best_time': 'Pagi hari',
      'tradition': 'Sarapan sehat',
    },
    {
      'name': 'Beberuk Terong',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/beberuk_terong.jpg',
      'description':
          'Lalapan terong bulat mentah dan kacang panjang dengan sambal tomat.',
      'history': 'Penetralisir rasa daging di masakan Lombok.',
      'ingredients': 'Terong bulat, Kacang panjang, Sambal',
      'taste_gurih': '3',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '3',
      'serving': 'Segar dan pedas nendang.',
      'culture': 'Pendamping wajib ayam bakar.',
      'best_time': 'Makan siang',
      'tradition': 'Lauk pelengkap',
    },
    {
      'name': 'Kolo',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/kolo.jpg',
      'description': 'Nasi bakar yang dimasak di dalam bambu khas Flores.',
      'history': 'Cara masak nomaden warga Flores zaman dahulu.',
      'ingredients': 'Beras, Bumbu, Bambu',
      'taste_gurih': '4',
      'taste_pedas': '1',
      'taste_manis': '1',
      'taste_asam': '0',
      'serving': 'Harum bambu bakar.',
      'culture': 'Disajikan di pesta syukuran panen.',
      'best_time': 'Makan siang',
      'tradition': 'Pesta panen',
    },
    {
      'name': 'Kue Rambut',
      'daerah': 'Nusa Tenggara',
      'kategori': 'Camilan',
      'img': 'assets/images/kue_rambut.jpg',
      'description':
          'Kue kering berbentuk sarang burung / rambut dari tepung beras nira.',
      'history': 'Jajanan khas Alor dan daratan Timor.',
      'ingredients': 'Tepung beras, Gula nira',
      'taste_gurih': '2',
      'taste_pedas': '0',
      'taste_manis': '4',
      'taste_asam': '0',
      'serving': 'Renyah dan manis.',
      'culture': 'Sajian teman minum teh masyarakat NTT.',
      'best_time': 'Sore hari',
      'tradition': 'Camilan tamu',
    },

    // ================= PAPUA (10) =================
    {
      'name': 'Papeda',
      'daerah': 'Papua',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/papeda.jpg',
      'description': 'Bubur sagu bening dan lengket yang tawar.',
      'history': 'Makanan pokok masyarakat Timur Indonesia.',
      'ingredients': 'Pati sagu, Air panas',
      'taste_gurih': '1',
      'taste_pedas': '0',
      'taste_manis': '0',
      'taste_asam': '0',
      'serving': 'Tidak dikunyah, langsung ditelan.',
      'culture': 'Simbol kehidupan pesisir.',
      'best_time': 'Makan siang',
      'tradition': 'Makan bersama',
    },
    {
      'name': 'Ikan Kuah Kuning',
      'daerah': 'Papua',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/ikan_kuah_kuning.jpg',
      'description': 'Sup ikan berkuah kuning segar dan sedikit asam pedas.',
      'history': 'Lauk wajib dan satu-satunya pendamping Papeda.',
      'ingredients': 'Ikan tongkol/tuna, Kunyit, Kemangi, Jeruk',
      'taste_gurih': '4',
      'taste_pedas': '3',
      'taste_manis': '1',
      'taste_asam': '4',
      'serving': 'Memberikan rasa untuk Papeda.',
      'culture': 'Rasa khas laut Papua.',
      'best_time': 'Makan siang',
      'tradition': 'Sajian laut',
    },
    {
      'name': 'Keladi Tumbuk',
      'daerah': 'Papua',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/keladi_tumbuk.jpg',
      'description':
          'Talas (keladi) rebus yang ditumbuk halus, sering dicampur sambal.',
      'history': 'Makanan pokok alternatif masyarakat pegunungan Papua.',
      'ingredients': 'Umbi keladi, Garam',
      'taste_gurih': '2',
      'taste_pedas': '1',
      'taste_manis': '1',
      'taste_asam': '0',
      'serving': 'Pengganti nasi.',
      'culture': 'Sajian suku pedalaman.',
      'best_time': 'Pagi/Siang',
      'tradition': 'Pangan lokal',
    },
    {
      'name': 'Udang Selingkuh',
      'daerah': 'Papua',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/udang_selingkuh.jpg',
      'description': 'Udang air tawar raksasa yang capitnya mirip kepiting.',
      'history': 'Banyak ditemukan di sungai-sungai Wamena.',
      'ingredients': 'Udang lobster air tawar',
      'taste_gurih': '5',
      'taste_pedas': '2',
      'taste_manis': '3',
      'taste_asam': '1',
      'serving': 'Bisa dibakar atau direbus.',
      'culture': 'Dinamakan selingkuh karena bentuk tubuh dan capitnya beda.',
      'best_time': 'Makan malam',
      'tradition': 'Hidangan mewah',
    },
    {
      'name': 'Ikan Bakar Manokwari',
      'daerah': 'Papua',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/ikan_bakar_manokwari.jpg',
      'description': 'Ikan bakar berbalur sambal mentah yang digiling kasar.',
      'history': 'Resep otentik warga Manokwari, Papua Barat.',
      'ingredients': 'Ikan tongkol, Sambal mentah',
      'taste_gurih': '4',
      'taste_pedas': '5',
      'taste_manis': '1',
      'taste_asam': '2',
      'serving': 'Sangat pedas menyengat.',
      'culture': 'Favorit para nelayan.',
      'best_time': 'Makan siang',
      'tradition': 'Hasil tangkapan',
    },
    {
      'name': 'Kue Lontar',
      'daerah': 'Papua',
      'kategori': 'Camilan',
      'img': 'assets/images/kue_lontar.jpg',
      'description': 'Pie susu besar khas Papua dengan mangkuk keramik.',
      'history': 'Pengaruh peninggalan Belanda (Ronde Tart).',
      'ingredients': 'Susu kental manis, Telur, Terigu',
      'taste_gurih': '2',
      'taste_pedas': '0',
      'taste_manis': '5',
      'taste_asam': '0',
      'serving': 'Disajikan saat perayaan.',
      'culture': 'Kue ulang tahun lokal.',
      'best_time': 'Sore hari',
      'tradition': 'Pesta perayaan',
    },
    {
      'name': 'Abon Gulung',
      'daerah': 'Papua',
      'kategori': 'Camilan',
      'img': 'assets/images/abon_gulung.jpg',
      'description': 'Roti gulung super besar dengan isian abon melimpah.',
      'history': 'Oleh-oleh modern yang menjadi ikon Sorong dan Manokwari.',
      'ingredients': 'Roti, Abon sapi, Mayones',
      'taste_gurih': '4',
      'taste_pedas': '0',
      'taste_manis': '3',
      'taste_asam': '0',
      'serving': 'Porsi mengenyangkan.',
      'culture': 'Buah tangan wajib turis.',
      'best_time': 'Pagi/Sore',
      'tradition': 'Oleh-oleh',
    },
    {
      'name': 'Aunu Senebre',
      'daerah': 'Papua',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/aunu_senebre.jpg',
      'description': 'Ikan teri nasi yang dicampur dengan irisan daun talas.',
      'history': 'Makanan unik masyarakat pesisir Papua.',
      'ingredients': 'Ikan teri, Daun talas, Kelapa parut',
      'taste_gurih': '4',
      'taste_pedas': '2',
      'taste_manis': '1',
      'taste_asam': '1',
      'serving': 'Kering tanpa kuah.',
      'culture': 'Sajian sederhana bergizi tinggi.',
      'best_time': 'Siang hari',
      'tradition': 'Lauk harian',
    },
    {
      'name': 'Sagu Lempeng',
      'daerah': 'Papua',
      'kategori': 'Camilan',
      'img': 'assets/images/sagu_lempeng.jpg',
      'description': 'Kue sagu keras berbentuk pipih kemerahan.',
      'history': 'Bekal perjalanan jauh warga Papua karena sangat awet.',
      'ingredients': 'Pati sagu cetak',
      'taste_gurih': '2',
      'taste_pedas': '0',
      'taste_manis': '1',
      'taste_asam': '0',
      'serving': 'Sangat keras, dicelup teh agar lunak.',
      'culture': 'Camilan orang tua.',
      'best_time': 'Pagi hari',
      'tradition': 'Teman ngopi',
    },
    {
      'name': 'Sambal Colo-Colo',
      'daerah': 'Papua',
      'kategori': 'Makanan Berat',
      'img': 'assets/images/sambal_colo_colo.jpg',
      'description':
          'Sambal cair segar dari kecap, perasan jeruk nipis, dan irisan tomat.',
      'history': 'Pengaruh budaya Maluku yang kuat di pesisir Papua.',
      'ingredients': 'Cabai, Tomat, Jeruk lemon cui, Kecap',
      'taste_gurih': '3',
      'taste_pedas': '4',
      'taste_manis': '3',
      'taste_asam': '5',
      'serving': 'Disriramkan ke ikan bakar.',
      'culture': 'Pendamping lauk yang wajib.',
      'best_time': 'Makan siang',
      'tradition': 'Penyedap rasa',
    },
  ];

  // --- LOGIKA FILTERING ---
  List<Map<String, String>> get _filteredFoods {
    return _allFoods.where((food) {
      final matchesSearch =
          food['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          food['daerah']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _categories[_selectedCategoryIndex] == 'Semua' ||
          food['kategori'] == _categories[_selectedCategoryIndex];
      final matchesRegion =
          _selectedRegion == 'Semua Daerah' ||
          food['daerah']!.contains(_selectedRegion);

      return matchesSearch && matchesCategory && matchesRegion;
    }).toList()..sort((a, b) {
      if (_selectedSort == 'A-Z') return a['name']!.compareTo(b['name']!);
      if (_selectedSort == 'Z-A') return b['name']!.compareTo(a['name']!);
      return 0;
    });
  }

  // --- BOTTOM SHEET FILTER KACA (DIPERBARUI) ---
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Biar lebih leluasa saat ditarik
      backgroundColor: Colors.transparent, // Background tembus pandang
      barrierColor: Colors.black.withOpacity(
        0.1,
      ), // INI KUNCINYA: Layar belakang transparan terang!
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Efek Blur
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.3),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter Pencarian',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: textDark),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Urutkan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildFilterChip('A-Z', _selectedSort == 'A-Z', () {
                            setModalState(() => _selectedSort = 'A-Z');
                            setState(() => _selectedSort = 'A-Z');
                          }),
                          const SizedBox(width: 8),
                          _buildFilterChip('Z-A', _selectedSort == 'Z-A', () {
                            setModalState(() => _selectedSort = 'Z-A');
                            setState(() => _selectedSort = 'Z-A');
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Daerah',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _regionOptions.map((region) {
                          return _buildFilterChip(
                            region,
                            _selectedRegion == region,
                            () {
                              setModalState(() => _selectedRegion = region);
                              setState(() => _selectedRegion = region);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: rustRed,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Terapkan Filter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper untuk Chip di dalam Bottom Sheet (Disesuaikan jadi agak transparan)
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? rustRed
              : Colors.white.withOpacity(
                  0.5,
                ), // Putih transparan biar nyatu sama kaca
          border: Border.all(color: isSelected ? rustRed : Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textDark,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedFoods = _filteredFoods;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Jelajahi Kuliner',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- SEARCH BAR GLASSMORPHISM ---
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
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) =>
                                  setState(() => _searchQuery = value),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.search,
                                  color: textDark.withOpacity(0.7),
                                ),
                                hintText: 'Cari dari 60 kuliner Nusantara...',
                                hintStyle: TextStyle(
                                  color: textDark.withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: IconButton(
                              icon: Icon(Icons.tune, color: rustRed),
                              onPressed: _showFilterBottomSheet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- TAB KATEGORI GLASSMORPHISM ---
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? rustRed.withOpacity(0.85)
                                  : Colors.white.withOpacity(0.4),
                              border: Border.all(
                                color: isSelected
                                    ? rustRed
                                    : Colors.white.withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                _categories[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : textDark,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${displayedFoods.length} makanan ditemukan',
                style: TextStyle(
                  fontSize: 12,
                  color: textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- GRID KARTU KACA ---
            Expanded(
              child: displayedFoods.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 40,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: displayedFoods.length,
                      itemBuilder: (context, index) =>
                          _buildGlassCard(displayedFoods[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: textLight.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Waduh, makanannya tidak ada!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Coba cari dengan kata kunci lain\natau pilih daerah yang berbeda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- WIDGET KARTU KACA ---
  Widget _buildGlassCard(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
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
