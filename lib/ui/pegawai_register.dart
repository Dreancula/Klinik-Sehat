import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_colors.dart';
import '../model/pegawai.dart';
import '../service/data_service.dart';
import '../widget/date_input_formatter.dart';

class PegawaiRegister extends StatefulWidget {
  const PegawaiRegister({super.key});

  @override
  State<PegawaiRegister> createState() => _PegawaiRegisterState();
}

class _PegawaiRegisterState extends State<PegawaiRegister> {
  int _currentStep = 1;

  // Step 1: Unique Code
  final _codeCtrl = TextEditingController();
  String? _verifiedCode;

  // Step 2: Employee Data
  final _formKey = GlobalKey<FormState>();
  final _nipCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _lokasiCtrl = TextEditingController();
  bool _isLoadingLocation = false;

  // Step 3: OTP Ala-ala
  final _otpCtrl = TextEditingController();
  String _simulatedOtp = "";

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nipCtrl.dispose();
    _namaCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _nomorTeleponCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _lokasiCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _verifikasiKodeAdmin() {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Masukkan kode registrasi unik terlebih dahulu!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (DataService.instance.isCodeValid(code)) {
      setState(() {
        _verifiedCode = code;
        _currentStep = 2;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kode \"$code\" valid! Silakan lengkapi data diri Anda."),
          backgroundColor: AppColors.accentGreen,
        ),
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
              Text("Kode Tidak Valid", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Kode registrasi yang dimasukkan salah atau sudah pernah digunakan.\n\nSilakan hubungi Admin klinik untuk meminta kode unik baru (kombinasi huruf & angka) di halaman Data Pegawai.",
            style: TextStyle(color: AppColors.primaryText),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _deteksiLokasiOtomatis() async {
    setState(() => _isLoadingLocation = true);

    // Simulasi deteksi GPS akurat
    await Future.delayed(const Duration(milliseconds: 900));

    final daftarLokasi = [
      "Klinik Pusat - Jl. Diponegoro No. 12, Jakarta (-6.2088, 106.8456)",
      "Klinik Cabang Sehat - Jl. Sudirman No. 88, Jakarta (-6.2190, 106.8220)",
      "Gedung Rawat Jalan - Jl. Gatot Subroto No. 45 (-6.2301, 106.8180)",
      "Poli Terpadu Medika - Jl. Rasuna Said Blok B2 (-6.2225, 106.8315)",
    ];

    final picked = daftarLokasi[Random().nextInt(daftarLokasi.length)];

    if (mounted) {
      setState(() {
        _lokasiCtrl.text = picked;
        _isLoadingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("📍 Lokasi penempatan berhasil dideteksi otomatis!"),
          backgroundColor: AppColors.accentGreen,
        ),
      );
    }
  }

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1996, 5, 20),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      setState(() {
        _tanggalLahirCtrl.text = "$day/$month/$year";
      });
    }
  }

  void _lanjutKeOtp() {
    if (_formKey.currentState!.validate()) {
      // Generate OTP 4 digit angka acak
      final randomOtp = (1000 + Random().nextInt(9000)).toString();
      setState(() {
        _simulatedOtp = randomOtp;
        _currentStep = 3;
      });
    }
  }

  void _verifikasiOtpDanSelesaikan() {
    final inputOtp = _otpCtrl.text.trim();
    if (inputOtp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Masukkan kode OTP verifikasi!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (inputOtp == _simulatedOtp) {
      // Berhasil: Simpan ke Data Pegawai
      final pegawaiBaru = Pegawai(
        nip: _nipCtrl.text.trim(),
        nama: _namaCtrl.text.trim(),
        tanggalLahir: _tanggalLahirCtrl.text.trim(),
        nomorTelepon: _nomorTeleponCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        lokasi: _lokasiCtrl.text.trim().isEmpty ? null : _lokasiCtrl.text.trim(),
      );

      DataService.instance.addPegawai(pegawaiBaru);
      if (_verifiedCode != null) {
        DataService.instance.consumeCode(_verifiedCode!, pegawaiBaru.nama);
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 28),
              SizedBox(width: 10),
              Text("Registrasi Berhasil!", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat, ${pegawaiBaru.nama}!\nAkun pegawai Anda telah berhasil terdaftar dan data otomatis tersinkronisasi ke Data Pegawai sistem klinik.",
                style: const TextStyle(color: AppColors.primaryText),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.pastelMint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("NIP: ${pegawaiBaru.nip}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Email: ${pegawaiBaru.email}"),
                    if (pegawaiBaru.lokasi != null) Text("Lokasi: ${pegawaiBaru.lokasi}"),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman Login
              },
              child: const Text("Selesai & Masuk"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kode OTP salah! Silakan periksa kembali kode yang dikirim."),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi Pegawai"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stepper Header Visual
              _buildStepProgress(),

              const SizedBox(height: 20),

              if (_currentStep == 1) _buildStep1KodeAdmin(),
              if (_currentStep == 2) _buildStep2FormPegawai(),
              if (_currentStep == 3) _buildStep3Otp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4F0E8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStepIndicator(1, "Kode Admin", _currentStep >= 1),
          Container(width: 30, height: 2, color: _currentStep >= 2 ? AppColors.accentGreen : Colors.grey.shade300),
          _buildStepIndicator(2, "Data Pegawai", _currentStep >= 2),
          Container(width: 30, height: 2, color: _currentStep >= 3 ? AppColors.accentGreen : Colors.grey.shade300),
          _buildStepIndicator(3, "OTP Ala-ala", _currentStep >= 3),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accentGreen : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "$step",
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.secondaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primaryText : AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  // ================= STEP 1 =================
  Widget _buildStep1KodeAdmin() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4F0E8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.pastelMint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.key_rounded, color: AppColors.accentGreen, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Verifikasi Kode Admin",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Masukkan kode registrasi unik kombinasi huruf & angka yang telah digenerate oleh Admin dari menu Data Pegawai.",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _codeCtrl,
            textCapitalization: TextCapitalization.characters,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: AppColors.primaryText,
            ),
            decoration: InputDecoration(
              labelText: "KODE REGISTRASI",
              hintText: "Contoh: ADM88K",
              prefixIcon: const Icon(Icons.vpn_key_outlined),
              fillColor: const Color(0xFFF7FCF9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text("Verifikasi Kode & Lanjut"),
            onPressed: _verifikasiKodeAdmin,
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.info_outline, size: 16),
              label: const Text("Belum punya kode? Minta ke Admin"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Minta kode registrasi unik ke Admin yang login di menu Data Pegawai."),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= STEP 2 =================
  Widget _buildStep2FormPegawai() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4F0E8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Data Diri Calon Pegawai",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.pastelMint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Kode: $_verifiedCode",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              "Data ini akan langsung ditampilkan pada Data Pegawai sistem klinik.",
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 18),

            // NIP (Hanya Angka)
            TextFormField(
              controller: _nipCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "NIP (Nomor Induk Pegawai)",
                hintText: "Contoh: 19950520",
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? "NIP tidak boleh kosong" : null,
            ),
            const SizedBox(height: 14),

            // Nama
            TextFormField(
              controller: _namaCtrl,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap Pegawai",
                hintText: "Contoh: Dr. Rina Melati",
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? "Nama tidak boleh kosong" : null,
            ),
            const SizedBox(height: 14),

            // Tanggal Lahir (Hanya Angka)
            TextFormField(
              controller: _tanggalLahirCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [DateInputFormatter()],
              decoration: InputDecoration(
                labelText: "Tanggal Lahir (Hanya Angka)",
                hintText: "DD/MM/YYYY (Contoh: 20/05/1996)",
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.date_range_rounded, color: AppColors.accentGreen),
                  onPressed: _pilihTanggal,
                  tooltip: "Pilih Kalender",
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return "Tanggal Lahir tidak boleh kosong";
                if (val.trim().length < 8) return "Format tanggal lahir belum lengkap (DD/MM/YYYY)";
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Nomor Telepon (Hanya Angka)
            TextFormField(
              controller: _nomorTeleponCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Nomor Telepon (Hanya Angka)",
                hintText: "Contoh: 081298765432",
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return "Nomor Telepon tidak boleh kosong";
                if (!RegExp(r'^[0-9]+$').hasMatch(val)) return "Nomor Telepon hanya boleh angka";
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Email
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Pegawai",
                hintText: "pegawai@klinik.com",
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? "Email tidak boleh kosong" : null,
            ),
            const SizedBox(height: 14),

            // Password
            TextFormField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password Akun",
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? "Password tidak boleh kosong" : null,
            ),
            const SizedBox(height: 14),

            // Lokasi Otomatis
            TextFormField(
              controller: _lokasiCtrl,
              decoration: InputDecoration(
                labelText: "Lokasi Tugas / Penempatan",
                hintText: "Otomatis dari tombol deteksi lokasi",
                prefixIcon: const Icon(Icons.pin_drop_outlined),
                suffixIcon: IconButton(
                  icon: _isLoadingLocation
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location_rounded, color: AppColors.accentGreen),
                  tooltip: "Deteksi Lokasi GPS",
                  onPressed: _isLoadingLocation ? null : _deteksiLokasiOtomatis,
                ),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? "Lokasi tidak boleh kosong" : null,
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.my_location_rounded, size: 16),
                label: const Text("📍 Ambil Lokasi Saya Sekarang"),
                onPressed: _isLoadingLocation ? null : _deteksiLokasiOtomatis,
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text("Lanjut ke Verifikasi OTP"),
              onPressed: _lanjutKeOtp,
            ),
          ],
        ),
      ),
    );
  }

  // ================= STEP 3 =================
  Widget _buildStep3Otp() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4F0E8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.pastelMint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.mark_email_read_rounded, color: AppColors.accentGreen, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Verifikasi OTP Ala-Ala",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "Kode OTP verifikasi telah dikirimkan ke nomor ${_nomorTeleponCtrl.text} dan email ${_emailCtrl.text}.",
            style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 16),

          // Simulasi Pesan Masuk SMS / Email Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F0),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBCE7D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sms_rounded, color: AppColors.accentGreen, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pesan Masuk [Simulasi OTP]:",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Kode verifikasi akun Anda adalah: $_simulatedOtp",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          TextFormField(
            controller: _otpCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 10,
              color: AppColors.accentGreen,
            ),
            decoration: InputDecoration(
              labelText: "MASUKKAN 4 DIGIT OTP",
              hintText: "••••",
              fillColor: const Color(0xFFF7FCF9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),

          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text("Verifikasi & Selesaikan Pendaftaran"),
            onPressed: _verifikasiOtpDanSelesaikan,
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text("Kirim Ulang Kode OTP"),
            onPressed: () {
              final newOtp = (1000 + Random().nextInt(9000)).toString();
              setState(() {
                _simulatedOtp = newOtp;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Kode OTP baru dikirimkan: $newOtp"),
                  backgroundColor: AppColors.accentGreen,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
