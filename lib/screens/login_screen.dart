import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      }
    } catch (e) {
      debugPrint('Firebase Login Failed: $e');
      if (mounted) {
        // Fallback statis, tetap masuk
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login gagal, masuk menggunakan mode statis')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA KONSISTEN NUSANTARA RASA ---
    const Color rustRed = Color(0xFFA84A3B);
    const Color bgCream = Color(0xFFF9F6F0);
    const Color textDark = Color(0xFF3E2723);

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND KREM DASAR
          Container(
            width: double.infinity,
            height: double.infinity,
            color: bgCream,
          ),

          // 2. BACKGROUND MOTIF NUSANTARA (BATIK/TENUN)
          // Menggunakan opacity agar tidak menabrak teks, dan color filter agar warnanya senada
          Opacity(
            opacity:
                0.15, // Transparansi motif (bisa dinaikkan kalau kurang jelas)
            child: Image.asset(
              'assets/images/bg_nusantara.jpg', // Gambar batik yang kamu download
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              color:
                  rustRed, // Menyulap motif batik menjadi warna merah bata khasmu
              colorBlendMode: BlendMode.srcATop,
              errorBuilder: (context, error, stackTrace) {
                // Fallback kalau kamu belum masukin gambarnya
                return const Center(
                  child: Text(
                    'Jangan lupa masukkan bg_nusantara.jpg',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),

          // 3. KONTEN UTAMA DENGAN EFEK GLASSMORPHISM (DIUPDATE LEBIH TEGAS)
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  // Menambahkan shadow di belakang kaca agar efek melayangnya sangat terlihat
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: rustRed.withOpacity(
                          0.15,
                        ), // Bayangan merah bata tipis
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 20,
                        sigmaY: 20,
                      ), // Blur dinaikkan agar lebih buram
                      child: Container(
                        width: 380,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            0.45,
                          ), // Warna kaca lebih solid
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(
                              0.8,
                            ), // Border putih lebih tegas
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // --- HEADER & LOGO SUPER BESAR ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.restaurant_menu,
                                          color: rustRed,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Nusantara Rasa',
                                          style: TextStyle(
                                            color: textDark.withOpacity(0.8),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                    ),
                                  ],
                                ),

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/images/nusantara_rasa_logo.png',
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 160,
                                        width: 160,
                                        color: Colors.white.withOpacity(0.5),
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                            size: 40,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // --- EMAIL INPUT ---
                            const Text(
                              'Email',
                              style: TextStyle(
                                color: textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              hint: 'dandielucky@student.polimedia.ac.id',
                              controller: _emailController,
                            ),
                            const SizedBox(height: 16),

                            // --- PASSWORD INPUT ---
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              hint: '••••••••',
                              isPassword: true,
                              controller: _passwordController,
                            ),
                            const SizedBox(height: 8),

                            // --- FORGOT PASSWORD ---
                            const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: textDark,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // --- SIGN IN BUTTON ---
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: SizedBox(
                                width: double.infinity,
                                height:
                                    45, // Diperbesar sedikit agar lebih enak diklik
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: textDark,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _isLoading ? null : _login,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Sign in',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // --- OR CONTINUE WITH ---
                            const Center(
                              child: Text(
                                'or continue with',
                                style: TextStyle(color: textDark, fontSize: 11),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // --- SOCIAL ICONS ---
                            Row(
                              children: [
                                _buildSocialButton(
                                  Icons.g_mobiledata,
                                  Colors.red,
                                ),
                                const SizedBox(width: 12),
                                _buildSocialButton(Icons.code, Colors.black),
                                const SizedBox(width: 12),
                                _buildSocialButton(Icons.facebook, Colors.blue),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // --- REGISTER TEXT ---
                            Center(
                              child: RichText(
                                text: const TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                    color: textDark,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Register for free',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: rustRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildTextField({required String hint, bool isPassword = false, TextEditingController? controller}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.8,
        ), // Putih agak transparan biar masuk tema glassmorphism
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          suffixIcon: isPassword
              ? const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey)
              : null,
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color iconColor) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
      ),
    );
  }
}
