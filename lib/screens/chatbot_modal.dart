import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/gemini_service.dart';

class ChatbotModal extends StatefulWidget {
  const ChatbotModal({super.key});

  @override
  State<ChatbotModal> createState() => _ChatbotModalState();
}

class _ChatbotModalState extends State<ChatbotModal> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _showSettings = false;

  final Color bgCream = const Color(0xFFFAF8F4);
  final Color textDark = const Color(0xFF3E2723);
  final Color rustRed = const Color(0xFFA84A3B);

  final List<Map<String, String>> _messages = [
    {
      'sender': 'bot',
      'text':
          'Halo! 👋 Saya Asisten Nusantara, didukung oleh Gemini AI. Ada yang ingin kamu tanyakan tentang kuliner Indonesia hari ini?',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  @override
  void dispose() {
    _controller.dispose();
    _apiKeyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadApiKey() async {
    final apiKey = await GeminiService.getApiKey();
    if (apiKey != null && mounted) {
      setState(() {
        _apiKeyController.text = apiKey;
      });
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, {'sender': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    // Panggil Gemini API (secara otomatis mendeteksi API key lokal)
    final reply = await GeminiService.sendMessage(text);

    if (mounted) {
      setState(() {
        _messages.insert(0, {'sender': 'bot', 'text': reply});
        _isTyping = false;
      });
    }
  }

  Future<void> _bukaAiStudio() async {
    final Uri url = Uri.parse('https://aistudio.google.com/app/apikey');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Tidak dapat membuka Google AI Studio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: rustRed,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Asisten Nusantara',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          _isTyping ? 'Sedang mengetik...' : 'Powered by Gemini AI',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _showSettings ? Icons.chat_bubble_outline_rounded : Icons.key_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _showSettings = !_showSettings),
                      tooltip: _showSettings ? 'Buka Chat' : 'Atur API Key',
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // API Key Settings Panel
          if (_showSettings)
            Container(
              color: bgCream,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaturan API Key Gemini 1.5',
                    style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dapatkan API Key Gemini gratis Anda dari Google AI Studio:',
                    style: TextStyle(color: textDark.withOpacity(0.7), fontSize: 11),
                  ),
                  GestureDetector(
                    onTap: _bukaAiStudio,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: const Text(
                        'https://aistudio.google.com/app/apikey',
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _apiKeyController,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan API Key AIzaSy...',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 11),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rustRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: () async {
                          await GeminiService.saveApiKey(_apiKeyController.text);
                          setState(() {
                            _showSettings = false;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('API Key berhasil disimpan!')),
                            );
                          }
                        },
                        child: const Text('Simpan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          await GeminiService.removeApiKey();
                          _apiKeyController.clear();
                          setState(() {
                            _showSettings = false;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('API Key berhasil dihapus!')),
                            );
                          }
                        },
                        tooltip: 'Hapus API Key',
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Chat area
          if (!_showSettings)
            SizedBox(
              height: 400,
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  // Typing indicator
                  if (_isTyping && index == 0) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16), topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDot(0), const SizedBox(width: 4),
                            _buildDot(200), const SizedBox(width: 4),
                            _buildDot(400),
                          ],
                        ),
                      ),
                    );
                  }

                  final msgIndex = _isTyping ? index - 1 : index;
                  final msg = _messages[msgIndex];
                  final isUser = msg['sender'] == 'user';

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? rustRed : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                          bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                        ),
                        border: isUser ? null : Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        msg['text']!,
                        style: TextStyle(color: isUser ? Colors.white : textDark, fontSize: 14, height: 1.4),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Input area
          if (!_showSettings)
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
                      enabled: !_isTyping,
                      decoration: InputDecoration(
                        hintText: _isTyping ? 'Menunggu balasan...' : 'Tanya seputar kuliner Indonesia...',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        filled: true, fillColor: bgCream,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: _isTyping ? null : _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: _isTyping ? Colors.grey : rustRed,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: _isTyping ? null : () => _sendMessage(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      builder: (context, value, child) {
        return Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3 + value * 0.4),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
