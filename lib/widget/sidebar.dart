import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../service/data_service.dart';
import '../ui/beranda.dart';
import '../ui/login.dart';
import '../ui/poli_page.dart';
import '../ui/pegawai_page.dart';
import '../ui/pasien_page.dart';
import '../ui/antrean_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: AppColors.danger),
            SizedBox(width: 10),
            Text(
              "Konfirmasi Keluar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          "Apakah Anda yakin ingin keluar dari akun?",
          style: TextStyle(color: AppColors.primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              DataService.instance.logout();
              Navigator.pop(context); // Tutup dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  void _konfirmasiResetData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.restart_alt_rounded, color: Color(0xFFE67E22)),
            SizedBox(width: 10),
            Text(
              "Reset Data Demo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          "Seluruh perubahan data Poli, Pegawai, Pasien, dan Antrean akan dikembalikan ke kondisi data awal bawaan. Lanjutkan?",
          style: TextStyle(color: AppColors.primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Batal",
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              Navigator.pop(context); // Tutup drawer
              await DataService.instance.resetToDefaultData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Data berhasil direset ke kondisi awal bawaan."),
                    backgroundColor: AppColors.accentGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE67E22)),
            child: const Text("Reset Sekarang"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = DataService.instance.currentUser;

    return Drawer(
      child: Container(
        color: const Color(0xFFF9FCFA),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.mainGradient,
              ),
              padding: const EdgeInsets.only(top: 48, bottom: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryText.withAlpha(25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      currentUser.role == "Admin"
                          ? Icons.admin_panel_settings_rounded
                          : Icons.person_rounded,
                      size: 34,
                      color: AppColors.accentGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentUser.nama,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentUser.email,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentUser.role,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context: context,
              icon: Icons.home_rounded,
              title: "Beranda",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Beranda()),
                );
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.medical_services_rounded,
              title: "Data Poli",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PoliPage()),
                );
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.badge_rounded,
              title: "Data Pegawai",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PegawaiPage()),
                );
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.people_alt_rounded,
              title: "Data Pasien",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PasienPage()),
                );
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.receipt_long_rounded,
              title: "Antrean & Pendaftaran",
              iconColor: const Color(0xFF8E44AD),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AntreanPage()),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Divider(color: Color(0xFFE2EFE7)),
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.restart_alt_rounded,
              title: "Reset Data Bawaan",
              iconColor: const Color(0xFFE67E22),
              textColor: const Color(0xFFD35400),
              onTap: () => _konfirmasiResetData(context),
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.logout_rounded,
              title: "Keluar",
              iconColor: AppColors.danger,
              textColor: AppColors.danger,
              onTap: () => _konfirmasiLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = AppColors.accentGreen,
    Color textColor = AppColors.primaryText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
