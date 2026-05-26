import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  static const String _apiKeyPrefKey = 'gemini_api_key';

  /// Mendapatkan API Key yang tersimpan dari SharedPreferences
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyPrefKey);
  }

  /// Menyimpan API Key ke SharedPreferences
  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPrefKey, apiKey.trim());
  }

  /// Menghapus API Key yang tersimpan
  static Future<void> removeApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyPrefKey);
  }

  /// Kirim pesan ke Gemini dan dapatkan balasannya
  static Future<String> sendMessage(String userMessage) async {
    final apiKey = await getApiKey();

    // Jika API Key tidak ada, berikan fallback offline beserta instruksi
    if (apiKey == null || apiKey.isEmpty) {
      final fallback = _fallbackResponse(userMessage);
      return '$fallback\n\n_(Catatan: Ini respon offline. Silakan atur API Key Gemini via ikon 🔑 di pojok kanan atas modal untuk menggunakan AI asli!)_';
    }

    try {
      // Menggunakan model Gemini 1.5 Flash gratis
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    '''Kamu adalah "Asisten Nusantara", chatbot resmi dari aplikasi Nusantara Rasa.
Tugasmu adalah membantu pengguna menjelajahi kekayaan kuliner Indonesia.

Aturan:
1. Jawab HANYA dalam Bahasa Indonesia yang ramah, hangat, dan santai.
2. Gunakan emoji yang relevan untuk membuat percakapan lebih hidup.
3. Fokus pada topik kuliner Indonesia: resep, sejarah makanan, rekomendasi tempat makan, bahan-bahan, dan budaya makan.
4. Jika ditanya di luar topik kuliner, arahkan kembali dengan sopan ke topik kuliner Indonesia.
5. Berikan jawaban yang informatif tapi tidak terlalu panjang (maksimal 3-4 kalimat).
6. Selalu semangat dan antusias soal makanan Indonesia!

Pertanyaan pengguna: $userMessage''',
              },
            ],
          },
        ],
        'generationConfig': {'temperature': 0.8, 'maxOutputTokens': 500},
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (text != null) {
          return text.toString().trim();
        }
        return 'Maaf, saya tidak bisa memproses jawaban saat ini 😅';
      } else {
        final errorData = jsonDecode(response.body);
        final errorMsg = errorData['error']?['message'] ?? 'Unknown error';

        // Jika API key tidak valid, berikan fallback offline
        if (response.statusCode == 400 || response.statusCode == 403) {
          final fallback = _fallbackResponse(userMessage);
          return '$fallback\n\n_(API Key tidak valid atau dibatasi. Menampilkan respon offline. Silakan periksa kembali API Key Anda via ikon 🔑)_';
        }

        return 'Terjadi kesalahan (${response.statusCode}): $errorMsg';
      }
    } catch (e) {
      // Fallback ke respon statis jika terjadi error jaringan
      final fallback = _fallbackResponse(userMessage);
      return '$fallback\n\n_(Koneksi bermasalah. Menampilkan respon offline.)_';
    }
  }

  /// Fallback response jika Gemini API tidak tersedia/offline
  static String _fallbackResponse(String text) {
    String lowerText = text.toLowerCase();

    if (lowerText.contains('halo') ||
        lowerText.contains('hai') ||
        lowerText.contains('hi') ||
        lowerText.contains('hey')) {
      return 'Halo juga! 👋 Saya Asisten Nusantara. Tanya apa saja seputar kuliner Indonesia ya!';
    } else if (lowerText.contains('rendang')) {
      return 'Rendang 🥩 adalah masakan kebanggaan Minangkabau! Dimasak perlahan dengan santan dan rempah hingga kering, pernah dinobatkan sebagai makanan terenak di dunia lho!';
    } else if (lowerText.contains('gudeg')) {
      return 'Gudeg 🤎 adalah kuliner manis khas Yogyakarta. Terbuat dari nangka muda yang dimasak berjam-jam dengan gula aren dan santan. Paling mantap dimakan pakai krecek pedas!';
    } else if (lowerText.contains('nasi goreng')) {
      return 'Nasi Goreng 🍳 adalah makanan sejuta umat Indonesia! Hampir setiap daerah punya versinya sendiri, tapi yang pakai kecap manis itu emang ciri khas Indonesia banget.';
    } else if (lowerText.contains('sate') || lowerText.contains('soto')) {
      return 'Sate dan Soto itu comfort food banget! 🍲 Dari Soto Lamongan, Sate Madura, sampai Soto Betawi. Kamu lebih suka yang kuah bening atau kuah santan?';
    } else if (lowerText.contains('rekomendasi') ||
        lowerText.contains('enak') ||
        lowerText.contains('lapar')) {
      return 'Kalau lagi pengen yang berkuah, coba Coto Makassar! 🔥 Tapi kalau suka pedas dan rempah, Ayam Betutu dari Bali wajib masuk list kamu!';
    } else if (lowerText.contains('terima kasih') ||
        lowerText.contains('makasih') ||
        lowerText.contains('thanks')) {
      return 'Sama-sama! ✨ Senang bisa ngobrol tentang kuliner Indonesia. Kalau butuh info lagi, jangan ragu panggil saya ya!';
    }

    return 'Wah, pertanyaan yang menarik! 😄 Saat ini saya sedang offline, jadi belum bisa jawab lengkap. Coba tanya saya tentang Rendang, Gudeg, atau minta rekomendasi makanan enak ya!';
  }
}
