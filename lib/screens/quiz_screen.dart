import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Warna Tema
  final Color bgCream = const Color(0xFFFAF8F4);
  final Color textDark = const Color(0xFF3E2723);
  final Color textLight = const Color(0xFF8B7360);
  final Color rustRed = const Color(0xFFA84A3B);

  // Variabel Logika Kuis
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedAnswerIndex;

  // Daftar Pertanyaan Kuis
  final List<Map<String, dynamic>> _questions = [
    {
      'question':
          'Masakan dari Sumatera Barat yang diakui sebagai salah satu makanan terenak di dunia adalah?',
      'options': ['Pempek', 'Gudeg', 'Rendang', 'Sate Lilit'],
      'answer': 2, // Index jawaban benar (Rendang)
    },
    {
      'question':
          'Bahan baku utama dalam pembuatan Pempek khas Palembang adalah?',
      'options': [
        'Daging Sapi & Tepung',
        'Ikan Tenggiri & Sagu',
        'Ayam & Kelapa',
        'Udang & Beras',
      ],
      'answer': 1,
    },
    {
      'question':
          'Gudeg adalah makanan khas Yogyakarta yang memiliki cita rasa manis. Bahan utama Gudeg adalah?',
      'options': [
        'Nangka Muda',
        'Daun Singkong',
        'Daging Kambing',
        'Tahu & Tempe',
      ],
      'answer': 0,
    },
    {
      'question':
          'Makanan berkuah kuning kental yang biasanya disajikan bersama Papeda di Indonesia Timur adalah?',
      'options': [
        'Soto Kuning',
        'Ikan Kuah Kuning',
        'Gulai Otak',
        'Sayur Lodeh',
      ],
      'answer': 1,
    },
    {
      'question': 'Ayam Betutu merupakan kuliner khas dari daerah mana?',
      'options': [
        'Jawa Timur',
        'Nusa Tenggara Barat',
        'Sulawesi Selatan',
        'Bali',
      ],
      'answer': 3,
    },
  ];

  // Fungsi saat memilih jawaban
  void _pickAnswer(int selectedIndex) {
    if (_isAnswered) return; // Kalau sudah jawab, gak bisa ganti jawaban

    setState(() {
      _isAnswered = true;
      _selectedAnswerIndex = selectedIndex;
      if (selectedIndex == _questions[_currentQuestionIndex]['answer']) {
        _score++; // Tambah skor kalau benar
      }
    });
  }

  // Fungsi ke pertanyaan selanjutnya
  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _isAnswered = false;
      _selectedAnswerIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan Layar Hasil (Jika Kuis Selesai)
    if (_currentQuestionIndex >= _questions.length) {
      return Scaffold(
        backgroundColor: bgCream,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 100,
                  color: Color(0xFFD9A05B),
                ), // Icon piala
                const SizedBox(height: 24),
                Text(
                  'Kuis Selesai!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Skor Kamu: $_score / ${_questions.length}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: rustRed,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _score >= 4
                      ? 'Luar biasa! Kamu ahli kuliner Nusantara!'
                      : 'Wah, kamu butuh eksplorasi rasa lebih banyak nih!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: textLight),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), // Kembali ke Beranda
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rustRed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Tampilan Layar Kuis
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: bgCream,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pertanyaan ${_currentQuestionIndex + 1} dari ${_questions.length}',
          style: TextStyle(color: textLight, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: Colors.grey.shade300,
                color: rustRed,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 40),

              // Pertanyaan
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  currentQuestion['question'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Pilihan Jawaban
              ...List.generate(currentQuestion['options'].length, (index) {
                final isCorrectAnswer = index == currentQuestion['answer'];
                final isSelected = index == _selectedAnswerIndex;

                // Menentukan warna tombol berdasarkan status jawaban
                Color btnColor = Colors.white;
                Color borderColor = Colors.grey.shade300;
                Color textColor = textDark;

                if (_isAnswered) {
                  if (isCorrectAnswer) {
                    btnColor = Colors.green.shade100;
                    borderColor = Colors.green;
                    textColor = Colors.green.shade800;
                  } else if (isSelected) {
                    btnColor = Colors.red.shade100;
                    borderColor = Colors.red;
                    textColor = Colors.red.shade800;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () => _pickAnswer(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: btnColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              currentQuestion['options'][index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                          if (_isAnswered && isCorrectAnswer)
                            const Icon(Icons.check_circle, color: Colors.green),
                          if (_isAnswered && isSelected && !isCorrectAnswer)
                            const Icon(Icons.cancel, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Tombol Lanjut (Muncul hanya jika sudah menjawab)
              if (_isAnswered)
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rustRed,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex == _questions.length - 1
                        ? 'Lihat Hasil'
                        : 'Pertanyaan Selanjutnya',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
