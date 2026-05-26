import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nusantara_rasa.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabel Users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'user',
        foto_profil TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabel Makanan
    await db.execute('''
      CREATE TABLE makanan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        daerah TEXT NOT NULL,
        kategori TEXT NOT NULL,
        img TEXT NOT NULL,
        description TEXT NOT NULL,
        history TEXT,
        ingredients TEXT,
        taste_gurih TEXT DEFAULT '0',
        taste_pedas TEXT DEFAULT '0',
        taste_manis TEXT DEFAULT '0',
        taste_asam TEXT DEFAULT '0',
        serving TEXT,
        culture TEXT,
        best_time TEXT,
        tradition TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tabel Favorit
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        makanan_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (makanan_id) REFERENCES makanan (id) ON DELETE CASCADE,
        UNIQUE(user_id, makanan_id)
      )
    ''');

    // Seed admin default
    final adminPassword = _hashPassword('admin123');
    await db.insert('users', {
      'nama': 'Administrator',
      'email': 'admin@nusantararasa.com',
      'password': adminPassword,
      'role': 'admin',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Seed user default
    final userPassword = _hashPassword('user123');
    await db.insert('users', {
      'nama': 'Dandie Lucky Maulana',
      'email': 'dandielucky@student.polimedia.ac.id',
      'password': userPassword,
      'role': 'user',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Seed data makanan awal
    await _seedMakanan(db);
  }

  // ======================== AUTH ========================
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<Map<String, dynamic>?> register(
      String nama, String email, String password) async {
    final db = await database;
    try {
      final id = await db.insert('users', {
        'nama': nama,
        'email': email,
        'password': _hashPassword(password),
        'role': 'user',
        'created_at': DateTime.now().toIso8601String(),
      });
      final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
      if (result.isNotEmpty) return result.first;
    } catch (e) {
      return null; // Email sudah terdaftar
    }
    return null;
  }

  // ======================== USER/PROFILE ========================
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> updateProfile(int id, String nama, String email) async {
    final db = await database;
    return await db.update(
      'users',
      {'nama': nama, 'email': email},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updatePassword(int id, String oldPassword, String newPassword) async {
    final db = await database;
    final hashedOld = _hashPassword(oldPassword);
    final user = await db.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [id, hashedOld],
    );
    if (user.isEmpty) return 0;
    return await db.update(
      'users',
      {'password': _hashPassword(newPassword)},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ======================== MAKANAN CRUD ========================
  Future<List<Map<String, dynamic>>> getAllMakanan() async {
    final db = await database;
    return await db.query('makanan', orderBy: 'name ASC');
  }

  Future<List<Map<String, dynamic>>> searchMakanan(String query) async {
    final db = await database;
    return await db.query(
      'makanan',
      where: 'name LIKE ? OR daerah LIKE ? OR kategori LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getMakananByKategori(String kategori) async {
    final db = await database;
    if (kategori == 'Semua') return getAllMakanan();
    return await db.query(
      'makanan',
      where: 'kategori = ?',
      whereArgs: [kategori],
      orderBy: 'name ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getMakananByDaerah(String daerah) async {
    final db = await database;
    if (daerah == 'Semua Daerah') return getAllMakanan();
    return await db.query(
      'makanan',
      where: 'daerah = ?',
      whereArgs: [daerah],
      orderBy: 'name ASC',
    );
  }

  Future<Map<String, dynamic>?> getMakananById(int id) async {
    final db = await database;
    final result = await db.query('makanan', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> insertMakanan(Map<String, dynamic> data) async {
    final db = await database;
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.insert('makanan', data);
  }

  Future<int> updateMakanan(int id, Map<String, dynamic> data) async {
    final db = await database;
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(
      'makanan',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMakanan(int id) async {
    final db = await database;
    return await db.delete('makanan', where: 'id = ?', whereArgs: [id]);
  }

  // ======================== FAVORITES ========================
  Future<int> toggleFavorite(int userId, int makananId) async {
    final db = await database;
    final existing = await db.query(
      'favorites',
      where: 'user_id = ? AND makanan_id = ?',
      whereArgs: [userId, makananId],
    );
    if (existing.isNotEmpty) {
      return await db.delete(
        'favorites',
        where: 'user_id = ? AND makanan_id = ?',
        whereArgs: [userId, makananId],
      );
    } else {
      await db.insert('favorites', {
        'user_id': userId,
        'makanan_id': makananId,
        'created_at': DateTime.now().toIso8601String(),
      });
      return 1;
    }
  }

  Future<bool> isFavorite(int userId, int makananId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'user_id = ? AND makanan_id = ?',
      whereArgs: [userId, makananId],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT m.* FROM makanan m
      INNER JOIN favorites f ON f.makanan_id = m.id
      WHERE f.user_id = ?
      ORDER BY f.created_at DESC
    ''', [userId]);
  }

  // ======================== SEED DATA ========================
  Future<void> _seedMakanan(Database db) async {
    final List<Map<String, dynamic>> foods = [
      // SUMATERA
      {'name': 'Rendang', 'daerah': 'Sumatera', 'kategori': 'Makanan Berat', 'img': 'assets/images/rendang.jpg', 'description': 'Olahan daging sapi dengan rempah dan santan yang dimasak berjam-jam hingga kering.', 'history': 'Berasal dari Minangkabau, teknik merandang digunakan untuk mengawetkan daging.', 'ingredients': 'Daging Sapi, Santan, Cabai, Serai, Lengkuas', 'taste_gurih': '5', 'taste_pedas': '4', 'taste_manis': '2', 'taste_asam': '1', 'serving': 'Dengan nasi hangat.', 'culture': 'Simbol kebanggaan adat.', 'best_time': 'Makan siang', 'tradition': 'Upacara Adat'},
      {'name': 'Pempek', 'daerah': 'Sumatera', 'kategori': 'Camilan', 'img': 'assets/images/pempek.jpg', 'description': 'Olahan ikan tenggiri dan sagu dengan kuah cuko pedas.', 'history': 'Akulturasi budaya lokal Palembang dan Tionghoa.', 'ingredients': 'Ikan, Sagu, Gula Batok, Cabai', 'taste_gurih': '4', 'taste_pedas': '4', 'taste_manis': '4', 'taste_asam': '4', 'serving': 'Digoreng garing.', 'culture': 'Oleh-oleh khas Palembang.', 'best_time': 'Sore hari', 'tradition': 'Camilan harian'},
      {'name': 'Mie Aceh', 'daerah': 'Sumatera', 'kategori': 'Makanan Berat', 'img': 'assets/images/mie_aceh.jpg', 'description': 'Mie tebal dengan bumbu kari pedas.', 'history': 'Pengaruh kuliner India, Tiongkok, dan Arab di Aceh.', 'ingredients': 'Mie kuning, Daging/Seafood, Rempah kari', 'taste_gurih': '5', 'taste_pedas': '5', 'taste_manis': '1', 'taste_asam': '1', 'serving': 'Dengan emping dan acar.', 'culture': 'Teman nongkrong di kedai kopi.', 'best_time': 'Malam hari', 'tradition': 'Budaya warung kopi'},
      {'name': 'Sate Padang', 'daerah': 'Sumatera', 'kategori': 'Makanan Berat', 'img': 'assets/images/sate_padang.jpg', 'description': 'Sate daging sapi dengan kuah kental kuning pedas.', 'history': 'Khas Minang dengan kuah dari tepung beras.', 'ingredients': 'Daging sapi, Tepung beras, Rempah', 'taste_gurih': '5', 'taste_pedas': '4', 'taste_manis': '1', 'taste_asam': '1', 'serving': 'Dengan ketupat.', 'culture': 'Sajian pesta adat.', 'best_time': 'Malam hari', 'tradition': 'Pasar malam'},
      {'name': 'Soto Medan', 'daerah': 'Sumatera', 'kategori': 'Makanan Berat', 'img': 'assets/images/soto_medan.jpg', 'description': 'Soto berkuah santan kuning kehijauan.', 'history': 'Khas kota Medan yang kaya rempah.', 'ingredients': 'Ayam/Sapi, Santan, Kapulaga', 'taste_gurih': '5', 'taste_pedas': '2', 'taste_manis': '1', 'taste_asam': '2', 'serving': 'Dengan perkedel.', 'culture': 'Sarapan pagi warga Medan.', 'best_time': 'Pagi hari', 'tradition': 'Sarapan keluarga'},
      {'name': 'Bika Ambon', 'daerah': 'Sumatera', 'kategori': 'Camilan', 'img': 'assets/images/bika_ambon.jpg', 'description': 'Kue kuning bersarang dengan aroma daun jeruk.', 'history': 'Meskipun namanya Ambon, kue ini asli dari Medan (Jalan Ambon).', 'ingredients': 'Tepung tapioka, Telur, Gula, Nira', 'taste_gurih': '1', 'taste_pedas': '0', 'taste_manis': '5', 'taste_asam': '0', 'serving': 'Dipotong kotak.', 'culture': 'Oleh-oleh wajib.', 'best_time': 'Sore hari', 'tradition': 'Hantaran'},
      // JAWA
      {'name': 'Nasi Goreng', 'daerah': 'Jawa', 'kategori': 'Makanan Berat', 'img': 'assets/images/nasi_goreng.jpg', 'description': 'Nasi digoreng dengan kecap manis dan rempah.', 'history': 'Adaptasi kuliner Tionghoa dengan cita rasa lokal Nusantara.', 'ingredients': 'Nasi, Kecap, Telur', 'taste_gurih': '5', 'taste_pedas': '3', 'taste_manis': '4', 'taste_asam': '1', 'serving': 'Dengan kerupuk dan acar.', 'culture': 'Makanan nasional.', 'best_time': 'Malam hari', 'tradition': 'Kuliner harian'},
      {'name': 'Gudeg', 'daerah': 'Jawa', 'kategori': 'Makanan Berat', 'img': 'assets/images/gudeg.jpg', 'description': 'Sayur nangka muda manis yang dimasak lama.', 'history': 'Makanan khas Jogja sejak abad 16.', 'ingredients': 'Nangka muda, Gula aren, Santan', 'taste_gurih': '3', 'taste_pedas': '1', 'taste_manis': '5', 'taste_asam': '0', 'serving': 'Dengan krecek pedas.', 'culture': 'Simbol kelembutan budaya Jawa.', 'best_time': 'Makan siang', 'tradition': 'Hidangan keraton'},
      {'name': 'Soto Ayam', 'daerah': 'Jawa', 'kategori': 'Makanan Berat', 'img': 'assets/images/soto_ayam.jpg', 'description': 'Sup ayam kuah kuning.', 'history': 'Perpaduan budaya Jawa dan Tiongkok (Caudo).', 'ingredients': 'Ayam, Kunyit, Soun', 'taste_gurih': '5', 'taste_pedas': '1', 'taste_manis': '1', 'taste_asam': '2', 'serving': 'Ditambah jeruk nipis.', 'culture': 'Comfort food.', 'best_time': 'Pagi hari', 'tradition': 'Sarapan'},
      {'name': 'Rawon', 'daerah': 'Jawa', 'kategori': 'Makanan Berat', 'img': 'assets/images/rawon.jpg', 'description': 'Sup daging berkuah hitam legam.', 'history': 'Telah ada sejak era Kerajaan Majapahit.', 'ingredients': 'Daging sapi, Kluwek', 'taste_gurih': '5', 'taste_pedas': '2', 'taste_manis': '2', 'taste_asam': '1', 'serving': 'Dengan telur asin dan tauge.', 'culture': 'Makanan kebanggaan Jawa Timur.', 'best_time': 'Makan siang', 'tradition': 'Acara hajatan'},
      {'name': 'Sate Madura', 'daerah': 'Jawa', 'kategori': 'Makanan Berat', 'img': 'assets/images/sate_madura.jpg', 'description': 'Sate ayam dengan bumbu kacang manis.', 'history': 'Resep dari para pelaut Madura.', 'ingredients': 'Daging ayam, Kacang tanah, Kecap', 'taste_gurih': '4', 'taste_pedas': '2', 'taste_manis': '5', 'taste_asam': '1', 'serving': 'Dengan lontong.', 'culture': 'Dijajakan malam hari.', 'best_time': 'Malam hari', 'tradition': 'Kuliner malam'},
      {'name': 'Es Cendol', 'daerah': 'Jawa', 'kategori': 'Minuman', 'img': 'assets/images/es_cendol.jpg', 'description': 'Minuman manis dengan buliran tepung beras hijau.', 'history': 'Minuman tradisional masyarakat Sunda.', 'ingredients': 'Tepung beras, Santan, Gula aren', 'taste_gurih': '2', 'taste_pedas': '0', 'taste_manis': '5', 'taste_asam': '0', 'serving': 'Dengan es serut.', 'culture': 'Pelepas dahaga rakyat.', 'best_time': 'Siang hari', 'tradition': 'Minuman pasar'},
      // SULAWESI
      {'name': 'Coto Makassar', 'daerah': 'Sulawesi', 'kategori': 'Makanan Berat', 'img': 'assets/images/coto_makassar.jpg', 'description': 'Sup daging/jeroan sapi dengan bumbu rempah kacang.', 'history': 'Diciptakan di era Kerajaan Gowa.', 'ingredients': 'Sapi, Kacang tanah, Rempah', 'taste_gurih': '5', 'taste_pedas': '2', 'taste_manis': '1', 'taste_asam': '2', 'serving': 'Bersama ketupat/burasa.', 'culture': 'Mempersatukan warga saat Idul Fitri.', 'best_time': 'Pagi/Siang', 'tradition': 'Perayaan'},
      {'name': 'Es Pisang Ijo', 'daerah': 'Sulawesi', 'kategori': 'Minuman', 'img': 'assets/images/es_pisang_ijo.jpg', 'description': 'Pisang balut adonan hijau dengan bubur sumsum dan sirup.', 'history': 'Kudapan turun-temurun Suku Bugis-Makassar.', 'ingredients': 'Pisang, Tepung beras, Sirup merah', 'taste_gurih': '2', 'taste_pedas': '0', 'taste_manis': '5', 'taste_asam': '0', 'serving': 'Dengan es serut.', 'culture': 'Takjil Ramadhan terpopuler.', 'best_time': 'Sore hari', 'tradition': 'Buka puasa'},
      {'name': 'Ikan Bakar Rica', 'daerah': 'Sulawesi', 'kategori': 'Makanan Berat', 'img': 'assets/images/ikan_bakar_rica.jpg', 'description': 'Ikan laut bakar dengan sambal rica-rica super pedas.', 'history': 'Ciri khas kuliner Minahasa, Manado.', 'ingredients': 'Ikan, Cabai rawit, Jahe, Jeruk nipis', 'taste_gurih': '4', 'taste_pedas': '5', 'taste_manis': '1', 'taste_asam': '3', 'serving': 'Dengan nasi dan kangkung.', 'culture': 'Kecintaan warga Manado pada rasa pedas.', 'best_time': 'Makan siang', 'tradition': 'Pesta seafood'},
      // BALI
      {'name': 'Ayam Betutu', 'daerah': 'Bali', 'kategori': 'Makanan Berat', 'img': 'assets/images/ayam_betutu.jpg', 'description': 'Ayam rebus perlahan dengan bumbu Base Genep pedas.', 'history': 'Aslinya makanan suci untuk persembahan dewa.', 'ingredients': 'Ayam, Base genep, Serai', 'taste_gurih': '4', 'taste_pedas': '5', 'taste_manis': '1', 'taste_asam': '1', 'serving': 'Disajikan utuh.', 'culture': 'Nilai spiritual tinggi.', 'best_time': 'Makan siang', 'tradition': 'Upacara keagamaan'},
      {'name': 'Sate Lilit', 'daerah': 'Bali', 'kategori': 'Makanan Berat', 'img': 'assets/images/sate_lilit.jpg', 'description': 'Daging giling yang dililitkan pada batang serai.', 'history': 'Lilitan melambangkan masyarakat Bali yang bersatu.', 'ingredients': 'Daging Ikan/Ayam, Kelapa parut, Serai', 'taste_gurih': '5', 'taste_pedas': '3', 'taste_manis': '2', 'taste_asam': '1', 'serving': 'Tanpa bumbu kacang.', 'culture': 'Sajian khas wajib di Bali.', 'best_time': 'Makan siang', 'tradition': 'Sajian harian'},
      {'name': 'Nasi Jinggo', 'daerah': 'Bali', 'kategori': 'Makanan Berat', 'img': 'assets/images/nasi_jinggo.jpg', 'description': 'Nasi bungkus porsi kecil khas Bali.', 'history': 'Mirip nasi kucing, populer sejak era 90-an.', 'ingredients': 'Nasi, Ayam suwir, Tempe, Sambal', 'taste_gurih': '4', 'taste_pedas': '4', 'taste_manis': '2', 'taste_asam': '1', 'serving': 'Dibungkus daun pisang.', 'culture': 'Penyelamat lapar malam hari.', 'best_time': 'Malam hari', 'tradition': 'Street food'},
      // NUSA TENGGARA
      {'name': 'Ayam Taliwang', 'daerah': 'Nusa Tenggara', 'kategori': 'Makanan Berat', 'img': 'assets/images/ayam_taliwang.jpg', 'description': 'Ayam kampung bakar dengan cabai dan terasi super pedas.', 'history': 'Khas dari Lombok, dulunya bekal perang kerajaan.', 'ingredients': 'Ayam, Cabai, Terasi Lombok', 'taste_gurih': '4', 'taste_pedas': '5', 'taste_manis': '2', 'taste_asam': '2', 'serving': 'Wajib dengan plecing kangkung.', 'culture': 'Ikon kuliner Lombok.', 'best_time': 'Makan siang', 'tradition': 'Jamuan tamu'},
      {'name': 'Se\'i Sapi', 'daerah': 'Nusa Tenggara', 'kategori': 'Makanan Berat', 'img': 'assets/images/sei_sapi.jpg', 'description': 'Daging sapi yang diasap berjam-jam dengan kayu kosambi.', 'history': 'Teknik pengawetan daging khas Kupang, NTT.', 'ingredients': 'Daging sapi, Garam, Rempah', 'taste_gurih': '5', 'taste_pedas': '2', 'taste_manis': '1', 'taste_asam': '1', 'serving': 'Diiris tipis, ditemani sambal lu\'at.', 'culture': 'Kini populer di seluruh Indonesia.', 'best_time': 'Makan siang', 'tradition': 'Oleh-oleh NTT'},
      // PAPUA
      {'name': 'Papeda', 'daerah': 'Papua', 'kategori': 'Makanan Berat', 'img': 'assets/images/papeda.jpg', 'description': 'Bubur sagu lengket khas Papua yang kenyal dan unik.', 'history': 'Makanan pokok masyarakat Papua sejak zaman dahulu.', 'ingredients': 'Sagu, Air', 'taste_gurih': '2', 'taste_pedas': '0', 'taste_manis': '0', 'taste_asam': '0', 'serving': 'Dengan ikan kuah kuning.', 'culture': 'Makanan pokok tradisional Papua.', 'best_time': 'Makan siang', 'tradition': 'Makanan sehari-hari'},
      {'name': 'Ikan Kuah Kuning', 'daerah': 'Papua', 'kategori': 'Makanan Berat', 'img': 'assets/images/ikan_kuah_kuning.jpg', 'description': 'Ikan segar dimasak dengan kuah kuning segar dan asam.', 'history': 'Pendamping wajib papeda dari generasi ke generasi.', 'ingredients': 'Ikan laut, Kunyit, Jeruk nipis, Cabai', 'taste_gurih': '4', 'taste_pedas': '3', 'taste_manis': '0', 'taste_asam': '4', 'serving': 'Disajikan dengan papeda.', 'culture': 'Pendamping utama papeda.', 'best_time': 'Makan siang', 'tradition': 'Kuliner rumahan'},
    ];

    for (var food in foods) {
      food['created_at'] = DateTime.now().toIso8601String();
      food['updated_at'] = DateTime.now().toIso8601String();
      await db.insert('makanan', food);
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
