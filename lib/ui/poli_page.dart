import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../service/data_service.dart';
import '../widget/sidebar.dart';
import 'poli_item.dart';
import 'poli_form.dart';

class PoliPage extends StatefulWidget {
  const PoliPage({super.key});

  @override
  State<PoliPage> createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
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

  @override
  Widget build(BuildContext context) {
    final allPoli = _dataService.listPoli;
    final filteredPoli = _searchQuery.isEmpty
        ? allPoli
        : allPoli
            .where((p) =>
                p.namaPoli.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Data Poli"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 26),
            tooltip: "Tambah Poli",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PoliForm()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Total Data
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              gradient: AppColors.mainGradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Layanan Poli: ${allPoli.length}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${filteredPoli.length} Ditampilkan",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
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
                hintText: "Cari nama poli...",
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
            child: filteredPoli.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.medical_services_outlined,
                          size: 56,
                          color: AppColors.secondaryText,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _searchQuery.isNotEmpty
                              ? "Tidak ada poli \"$_searchQuery\""
                              : "Belum ada data poli",
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
                    itemCount: filteredPoli.length,
                    itemBuilder: (context, index) {
                      return PoliItem(poli: filteredPoli[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Poli"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PoliForm()),
          );
        },
      ),
    );
  }
}
