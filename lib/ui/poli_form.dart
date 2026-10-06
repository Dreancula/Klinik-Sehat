import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/poli.dart';
import '../service/data_service.dart';
import 'poli_detail.dart';

class PoliForm extends StatefulWidget {
  const PoliForm({super.key});

  @override
  State<PoliForm> createState() => _PoliFormState();
}

class _PoliFormState extends State<PoliForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPoliCtrl = TextEditingController();

  @override
  void dispose() {
    _namaPoliCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Poli")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4F0E8)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryText.withAlpha(8),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Formulir Layanan Poli",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Masukkan nama poli baru yang akan ditambahkan ke sistem klinik.",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _namaPoliCtrl,
                        decoration: const InputDecoration(
                          labelText: "Nama Poli",
                          hintText: "Contoh: Poli Mata, Poli THT",
                          prefixIcon: Icon(Icons.medical_services_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Nama Poli tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_rounded),
                  label: const Text("Simpan Data Poli"),
                  onPressed: _simpan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final poli = Poli(namaPoli: _namaPoliCtrl.text.trim());
      DataService.instance.addPoli(poli);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Poli berhasil ditambahkan"),
          backgroundColor: AppColors.accentGreen,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PoliDetail(poli: poli)),
      );
    }
  }
}
