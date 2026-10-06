import 'package:flutter/services.dart';

/// Formatter untuk tanggal lahir: hanya menerima angka dan otomatis memformat menjadi DD/MM/YYYY
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Ambil hanya karakter angka
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Maksimal 8 digit (DDMMYYYY)
    final clamped = digitsOnly.length > 8 ? digitsOnly.substring(0, 8) : digitsOnly;
    
    final buffer = StringBuffer();
    for (int i = 0; i < clamped.length; i++) {
      if (i == 2 || i == 4) {
        buffer.write('/');
      }
      buffer.write(clamped[i]);
    }
    
    final formattedString = buffer.toString();
    return TextEditingValue(
      text: formattedString,
      selection: TextSelection.collapsed(offset: formattedString.length),
    );
  }
}
