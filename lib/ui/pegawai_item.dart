import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/pegawai.dart';
import 'pegawai_detail.dart';

class PegawaiItem extends StatelessWidget {
  final Pegawai pegawai;

  const PegawaiItem({super.key, required this.pegawai});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5F1EB)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFD6EAF8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.badge_rounded,
            color: Color(0xFF2980B9),
            size: 24,
          ),
        ),
        title: Text(
          pegawai.nama,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.pastelMint,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "NIP: ${pegawai.nip}",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pegawai.email,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.secondaryText,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PegawaiDetail(pegawai: pegawai),
            ),
          );
        },
      ),
    );
  }
}
