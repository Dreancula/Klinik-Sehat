import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/pegawai.dart';
import '../service/data_service.dart';
import 'beranda.dart';
import 'pegawai_register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login() {
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    // Cek Admin Default
    final isAdmin = (username == "admin" && password == "admin");

    // Atau Cek Pegawai Terdaftar
    Pegawai? matchingPegawai;
    try {
      matchingPegawai = DataService.instance.listPegawai.firstWhere(
        (p) =>
            (p.email.toLowerCase() == username.toLowerCase() || p.nip == username) &&
            p.password == password,
      );
    } catch (_) {
      matchingPegawai = null;
    }

    if (isAdmin || matchingPegawai != null) {
      if (isAdmin) {
        DataService.instance.setCurrentUser(
          UserModel(
            nama: "Administrator",
            email: "admin@klinik.com",
            role: "Admin",
          ),
        );
      } else {
        DataService.instance.setCurrentUser(
          UserModel(
            nama: matchingPegawai!.nama,
            email: matchingPegawai.email,
            role: "Pegawai Medis",
            nip: matchingPegawai.nip,
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAdmin
                ? "Selamat datang, Administrator!"
                : "Selamat datang, ${matchingPegawai!.nama}!",
          ),
          backgroundColor: AppColors.accentGreen,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Beranda()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.error_outline_rounded, color: AppColors.danger),
              SizedBox(width: 8),
              Text("Login Gagal", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Username/Email atau Password tidak valid.\n\nTips:\n• Admin: admin / admin\n• Pegawai: Gunakan Email / NIP & password yang sudah terdaftar.",
            style: TextStyle(color: AppColors.primaryText),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryText.withAlpha(20),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_hospital_rounded,
                      color: AppColors.accentGreen,
                      size: 44,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "KLINIK SEHAT",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Sistem Informasi Manajemen Klinik",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Card Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryText.withAlpha(15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Masuk ke Akun",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Silakan login sebagai Admin atau Tenaga Medis.",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),

                          const SizedBox(height: 22),

                          TextFormField(
                            controller: _usernameCtrl,
                            decoration: const InputDecoration(
                              labelText: "Username / Email / NIP",
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.secondaryText,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 26),

                          ElevatedButton.icon(
                            icon: const Icon(Icons.login_rounded),
                            label: const Text("Masuk"),
                            onPressed: _login,
                          ),

                          const SizedBox(height: 18),
                          const Divider(color: Color(0xFFEAF2ED)),
                          const SizedBox(height: 14),

                          // Tombol Daftar Pegawai Baru
                          OutlinedButton.icon(
                            icon: const Icon(Icons.person_add_rounded, size: 18),
                            label: const Text("Registrasi Pegawai Baru"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.accentGreen,
                              side: const BorderSide(color: AppColors.accentGreen, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PegawaiRegister(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "© 2026 Klinik Sehat • Tugas Pemrograman Mobile",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
