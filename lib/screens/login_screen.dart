import 'dart:ui';
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isRegisterMode = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    _animController.reverse().then((_) {
      setState(() {
        _isRegisterMode = !_isRegisterMode;
        _emailController.clear();
        _passwordController.clear();
        _namaController.clear();
        _confirmPasswordController.clear();
      });
      _animController.forward();
    });
  }

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showSnackBar('Email dan password harus diisi!', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await DatabaseHelper.instance.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null && mounted) {
        _showSnackBar('Login berhasil! Selamat datang, ${user['nama']}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainWrapper(
              userId: user['id'] as int,
              userRole: user['role'] as String,
              userName: user['nama'] as String,
            ),
          ),
        );
      } else if (mounted) {
        _showSnackBar('Email atau password salah!', isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Terjadi kesalahan: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    if (_namaController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showSnackBar('Semua field harus diisi!', isError: true);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Password dan konfirmasi tidak cocok!', isError: true);
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar('Password minimal 6 karakter!', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await DatabaseHelper.instance.register(
        _namaController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null && mounted) {
        _showSnackBar('Registrasi berhasil! Silakan login.');
        _toggleMode();
      } else if (mounted) {
        _showSnackBar('Email sudah terdaftar!', isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Terjadi kesalahan: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color rustRed = Color(0xFFA84A3B);
    const Color bgCream = Color(0xFFF9F6F0);
    const Color textDark = Color(0xFF3E2723);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background krem
          Container(
            width: double.infinity,
            height: double.infinity,
            color: bgCream,
          ),

          // 2. Background motif batik
          Opacity(
            opacity: 0.15,
            child: Image.asset(
              'assets/images/bg_nusantara.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              color: rustRed,
              colorBlendMode: BlendMode.srcATop,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox(),
            ),
          ),

          // 3. Form Login/Register dengan Glassmorphism
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: rustRed.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        width: 380,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header & Logo
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                            color:
                                                textDark.withOpacity(0.8),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _isRegisterMode
                                          ? 'Register'
                                          : 'Login',
                                      style: const TextStyle(
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
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        height: 120,
                                        width: 120,
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
                            const SizedBox(height: 16),

                            // Nama (Register only)
                            if (_isRegisterMode) ...[
                              const Text(
                                'Nama Lengkap',
                                style: TextStyle(
                                  color: textDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildTextField(
                                hint: 'Masukkan nama lengkap',
                                controller: _namaController,
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Email
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
                              hint: _isRegisterMode
                                  ? 'contoh@email.com'
                                  : 'dandielucky@student.polimedia.ac.id',
                              controller: _emailController,
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 16),

                            // Password
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
                              obscure: _obscurePassword,
                              onToggle: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),

                            // Confirm Password (Register only)
                            if (_isRegisterMode) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Konfirmasi Password',
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
                                controller: _confirmPasswordController,
                                obscure: _obscureConfirm,
                                onToggle: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                              ),
                            ],
                            const SizedBox(height: 24),

                            // Submit Button
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: textDark,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : (_isRegisterMode
                                          ? _register
                                          : _login),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          _isRegisterMode
                                              ? 'Daftar Akun'
                                              : 'Sign in',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Info akun default (Login mode only)
                            if (!_isRegisterMode) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: rustRed.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: rustRed.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            size: 14, color: rustRed),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Akun Demo:',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    _buildDemoAccount(
                                      'Admin',
                                      'admin@nusantararasa.com',
                                      'admin123',
                                    ),
                                    const SizedBox(height: 4),
                                    _buildDemoAccount(
                                      'User',
                                      'dandielucky@student.polimedia.ac.id',
                                      'user123',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Toggle Login/Register
                            Center(
                              child: GestureDetector(
                                onTap: _toggleMode,
                                child: RichText(
                                  text: TextSpan(
                                    text: _isRegisterMode
                                        ? 'Sudah punya akun? '
                                        : "Belum punya akun? ",
                                    style: const TextStyle(
                                      color: textDark,
                                      fontSize: 12,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: _isRegisterMode
                                            ? 'Login di sini'
                                            : 'Daftar gratis',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: rustRed,
                                        ),
                                      ),
                                    ],
                                  ),
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

  // ---- Helper Widgets ----
  Widget _buildDemoAccount(String role, String email, String password) {
    return Text(
      '$role: $email / $password',
      style: TextStyle(
        fontSize: 10,
        color: const Color(0xFF3E2723).withOpacity(0.7),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    bool isPassword = false,
    TextEditingController? controller,
    IconData? icon,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          prefixIcon: icon != null
              ? Icon(icon, size: 18, color: Colors.grey.shade500)
              : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onPressed: onToggle,
                )
              : null,
        ),
      ),
    );
  }
}
