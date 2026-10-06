import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_colors.dart';
import '../service/data_service.dart';
import '../widget/sidebar.dart';
import 'pegawai_item.dart';
import 'pegawai_form.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({super.key});

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  final DataService _dataService = DataService.instance;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _dataService.addListener(_onDataChanged);
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  void _tampilkanDialogKodeRegistrasi() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final codes = _dataService.registrationCodes;
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Kelola Kode Registrasi Pegawai",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Text(
                    "Calon pegawai harus memasukkan kode unik (huruf & angka) ini saat mendaftar akun agar data otomatis masuk ke sistem.",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.vpn_key_rounded, size: 20),
                    label: const Text("Generate Kode Unik Baru"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      final newCode = _dataService.generateRegistrationCode();
                      setModalState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Kode unik \"$newCode\" berhasil dibuat!"),
                          backgroundColor: AppColors.accentGreen,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Daftar Kode Registrasi Admin:",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: codes.isEmpty
                        ? const Center(
                            child: Text(
                              "Belum ada kode registrasi",
                              style: TextStyle(color: AppColors.secondaryText),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: codes.length,
                            itemBuilder: (context, index) {
                              final reg = codes[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: reg.isUsed
                                      ? const Color(0xFFF2F4F4)
                                      : const Color(0xFFE8F8F0),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: reg.isUsed
                                        ? const Color(0xFFD5DBDB)
                                        : const Color(0xFFC3E6D5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          reg.isUsed
                                              ? Icons.check_circle_outline
                                              : Icons.key_rounded,
                                          size: 18,
                                          color: reg.isUsed
                                              ? AppColors.secondaryText
                                              : AppColors.accentGreen,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          reg.code,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: reg.isUsed
                                                ? AppColors.secondaryText
                                                : AppColors.primaryText,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: reg.isUsed
                                                ? Colors.grey.shade300
                                                : AppColors.pastelGreen,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            reg.isUsed ? "Terpakai" : "Aktif",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: reg.isUsed
                                                  ? AppColors.secondaryText
                                                  : AppColors.accentGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!reg.isUsed)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.copy_rounded,
                                          size: 18,
                                          color: AppColors.accentGreen,
                                        ),
                                        tooltip: "Salin Kode",
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: reg.code),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Kode ${reg.code} berhasil disalin ke clipboard!",
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allPegawai = _dataService.listPegawai;
    final filteredPegawai = _searchQuery.isEmpty
        ? allPegawai
        : allPegawai.where((p) {
            final q = _searchQuery.toLowerCase();
            return p.nama.toLowerCase().contains(q) ||
                p.nip.toLowerCase().contains(q) ||
                p.email.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Data Pegawai"),
        actions: [
          IconButton(
            icon: const Icon(Icons.key_rounded),
            tooltip: "Kode Unik Registrasi",
            onPressed: _tampilkanDialogKodeRegistrasi,
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 26),
            tooltip: "Tambah Pegawai Manual",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PegawaiForm()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              gradient: AppColors.mainGradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Pegawai: ${allPegawai.length}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${filteredPegawai.length} Ditampilkan",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.vpn_key_rounded, size: 16),
                  label: const Text(
                    "Kode Unik",
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.accentGreen,
                    elevation: 1,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: _tampilkanDialogKodeRegistrasi,
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: "Cari nama, NIP, atau email pegawai...",
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondaryText),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => _searchCtrl.clear(),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFD6E9DF)),
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredPegawai.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          size: 56,
                          color: AppColors.secondaryText,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _searchQuery.isNotEmpty
                              ? "Tidak ditemukan pegawai \"$_searchQuery\""
                              : "Belum ada data pegawai",
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
                    itemCount: filteredPegawai.length,
                    itemBuilder: (context, index) {
                      return PegawaiItem(pegawai: filteredPegawai[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Pegawai"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PegawaiForm()),
          );
        },
      ),
    );
  }
}
