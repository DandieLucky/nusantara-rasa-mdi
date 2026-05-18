import 'package:flutter/material.dart';

class ChatbotModal extends StatefulWidget {
  const ChatbotModal({super.key});

  @override
  State<ChatbotModal> createState() => _ChatbotModalState();
}

class _ChatbotModalState extends State<ChatbotModal> {
  final TextEditingController _controller = TextEditingController();

  // Warna Tema
  final Color bgCream = const Color(0xFFFAF8F4);
  final Color textDark = const Color(0xFF3E2723);
  final Color rustRed = const Color(0xFFA84A3B);

  // Daftar pesan awal
  final List<Map<String, String>> _messages = [
    {
      'sender': 'bot',
      'text':
          'Halo! Saya Asisten Nusantara. Ada yang ingin kamu tanyakan tentang kuliner Indonesia hari ini?',
    },
  ];

  // Logika "Otak" Chatbot yang Baru
  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // 1. Masukkan pesan user ke layar
    setState(() {
      _messages.insert(0, {'sender': 'user', 'text': text});
    });

    _controller.clear();

    // 2. Beri jeda 1 detik agar seolah-olah Bot sedang "mengetik"
    Future.delayed(const Duration(seconds: 1), () {
      // Default balasan kalau bot nggak ngerti (Dibuat lebih ramah)
      String botReply =
          "Wah, pertanyaan yang menarik! Sayangnya memori saya baru diisi seputar kuliner Nusantara nih 😅. Coba deh tanya saya tentang asal usul Rendang, Gudeg, atau minta rekomendasi makanan enak!";

      String lowerText = text.toLowerCase();

      // --- PENGECEKAN KATA KUNCI YANG LEBIH PINTAR & RAMAH ---

      // Sapaan
      if (lowerText.contains('halo') ||
          lowerText.contains('hai') ||
          lowerText.contains('hi') ||
          lowerText.contains('hey') ||
          lowerText.contains('pagi') ||
          lowerText.contains('siang') ||
          lowerText.contains('malam') ||
          lowerText.contains('bro') ||
          lowerText.contains('min')) {
        botReply =
            "Halo juga! 👋 Selamat datang di Nusantara Rasa. Ada yang bisa saya bantu? Kamu bisa tanya soal resep, asal daerah makanan, atau minta rekomendasi kuliner lho!";
      }
      // Identitas Bot
      else if (lowerText.contains('siapa kamu') ||
          lowerText.contains('namamu') ||
          lowerText.contains('kamu siapa')) {
        botReply =
            "Saya adalah Asisten Nusantara, chatbot pintar yang dibuat khusus untuk menemanimu menjelajahi kekayaan kuliner Indonesia di aplikasi ini! 🤖🍲";
      }
      // Info Makanan Spesifik
      else if (lowerText.contains('rendang')) {
        botReply =
            "Ah, Rendang! 🥩 Masakan kebanggaan Minangkabau ini dimasak perlahan dengan santan dan rempah. Fun fact: Rendang pernah dinobatkan sebagai salah satu makanan terenak di dunia lho! Udah pernah coba?";
      } else if (lowerText.contains('gudeg')) {
        botReply =
            "Gudeg itu kuliner manis khas Yogyakarta 🤎. Terbuat dari nangka muda yang dimasak berjam-jam dengan gula aren dan santan. Paling mantap kalau dimakan pakai krecek pedas dan telur pindang!";
      } else if (lowerText.contains('papeda')) {
        botReply =
            "Papeda adalah kebanggaan Indonesia Timur (Maluku dan Papua). Teksturnya unik banget, lengket seperti lem karena terbuat dari sagu, dan juara banget rasanya kalau diseruput bareng Ikan Kuah Kuning! 🐟";
      } else if (lowerText.contains('nasi goreng') ||
          lowerText.contains('nasgor')) {
        botReply =
            "Nasi Goreng! 🍳 Makanan sejuta umat Nusantara. Hampir setiap daerah punya versinya sendiri, tapi yang pakai kecap manis itu emang ciri khas Indonesia banget.";
      } else if (lowerText.contains('sate') || lowerText.contains('soto')) {
        botReply =
            "Sate dan Soto itu comfort food banget! Di Jawa Timur ada Soto Lamongan dan Sate Madura. Kalau di Jakarta ada Soto Betawi. Kamu lebih suka tim kuah bening atau kuah santan nih? 🍲";
      }
      // Rekomendasi
      else if (lowerText.contains('rekomendasi') ||
          lowerText.contains('enak') ||
          lowerText.contains('lapar') ||
          lowerText.contains('makan apa')) {
        botReply =
            "Kalau cuaca lagi dingin dan pengen yang berkuah segar, saya rekomen Coto Makassar! Tapi kalau kamu pencinta pedas dan kaya rempah, Ayam Betutu dari Bali wajib masuk list kamu hari ini! 🔥";
      }
      // Ucapan Terima Kasih
      else if (lowerText.contains('terima kasih') ||
          lowerText.contains('makasih') ||
          lowerText.contains('thanks') ||
          lowerText.contains('oke') ||
          lowerText.contains('sip')) {
        botReply =
            "Sama-sama! Senang bisa ngobrol sama kamu. Kalau butuh info kuliner lagi, jangan ragu panggil saya ya! Selamat menjelajahi rasa asli Indonesia! ✨";
      }

      // 3. Masukkan balasan bot ke layar
      setState(() {
        _messages.insert(0, {'sender': 'bot', 'text': botReply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Chatbot
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: rustRed,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.smart_toy, color: Color(0xFFA84A3B)),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Asisten Nusantara',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Area Percakapan
          SizedBox(
            height: 400,
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? rustRed : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : Radius.zero,
                        bottomRight: isUser
                            ? Radius.zero
                            : const Radius.circular(16),
                      ),
                      border: isUser
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : textDark,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Area Ketik Pesan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ketik sapaan atau tanya kuliner...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: bgCream,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: rustRed,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
