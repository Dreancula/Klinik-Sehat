import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../service/data_service.dart';
import '../widget/sidebar.dart';
import 'poli_page.dart';
import 'pegawai_page.dart';
import 'pasien_page.dart';
import 'antrean_page.dart';
import 'pendaftaran_form.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final DataService _dataService = DataService.instance;

  @override
  void initState() {
    super.initState();
    _dataService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int countPoli = _dataService.listPoli.length;
    int countPegawai = _dataService.listPegawai.length;
    int countPasien = _dataService.listPasien.length;
    int countAntreanMenunggu = _dataService.listPendaftaran
        .where((p) => p.status == 'Menunggu')
        .length;
    int countAntreanAktif = _dataService.listPendaftaran
        .where((p) => p.status == 'Menunggu' || p.status == 'Sedang Diperiksa')
        .length;

    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Klinik Sehat"),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: "Daftar Pasien Berobat",
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PendaftaranForm()),
            ),
          ),
          IconButton(
            tooltip: "Daftar Antrean",
            icon: const Icon(Icons.confirmation_number_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AntreanPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner with pastel gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                gradient: AppColors.mainGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Datang, ${_dataService.currentUser.nama} 👋",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Login sebagai ${_dataService.currentUser.role} • Sistem Klinik",
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryText.withAlpha(20),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_hospital_rounded,
                          color: AppColors.accentGreen,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Live Antrean Card Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFC7EBD7)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGreen.withAlpha(20),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.pastelMint,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.queue_play_next_rounded,
                                color: AppColors.accentGreen,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Status Antrean Hari Ini",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "$countAntreanMenunggu menunggu giliran ($countAntreanAktif aktif)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: countAntreanAktif > 0
                                ? const Color(0xFFFEF3D6)
                                : AppColors.pastelMint,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            countAntreanAktif > 0 ? "LIVE" : "TERKENDALI",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: countAntreanAktif > 0
                                  ? const Color(0xFFD35400)
                                  : AppColors.accentGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                            label: const Text(
                              "Daftar Berobat",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PendaftaranForm()),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.accentGreen,
                              side: const BorderSide(color: AppColors.accentGreen),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.confirmation_number_outlined, size: 18),
                            label: const Text(
                              "Kelola Antrean",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AntreanPage()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Statistics Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Text(
                "Ringkasan Data Klinik",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Stats Cards Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: "Data Poli",
                      count: "$countPoli",
                      icon: Icons.medical_services_rounded,
                      color: AppColors.accentGreen,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PoliPage()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: "Data Pegawai",
                      count: "$countPegawai",
                      icon: Icons.badge_rounded,
                      color: const Color(0xFF2980B9),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PegawaiPage()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: "Data Pasien",
                      count: "$countPasien",
                      icon: Icons.people_alt_rounded,
                      color: const Color(0xFFE67E22),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PasienPage()),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Text(
                "Menu Cepat",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _buildQuickActionTile(
                    title: "Antrean & Pendaftaran Berobat",
                    subtitle: "Daftar pasien baru ke poli & panggil antrean dokter",
                    icon: Icons.confirmation_number_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AntreanPage()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildQuickActionTile(
                    title: "Kelola Data Poli",
                    subtitle: "Tambah, ubah, dan hapus layanan spesialis poli",
                    icon: Icons.medical_services_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PoliPage()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildQuickActionTile(
                    title: "Kelola Data Pegawai & Kode Unik",
                    subtitle: "Manajemen dokter, perawat, & kode registrasi admin",
                    icon: Icons.badge_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PegawaiPage()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildQuickActionTile(
                    title: "Kelola Data Pasien",
                    subtitle: "Manajemen rekam medis dan data kunjungan pasien",
                    icon: Icons.personal_injury_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PasienPage()),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4F0E8)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryText.withAlpha(12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4F0E8)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryText.withAlpha(8),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.pastelMint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.accentGreen, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
