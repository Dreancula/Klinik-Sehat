class Poli {
  String? id;
  String namaPoli;

  Poli({this.id, required this.namaPoli});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaPoli': namaPoli,
    };
  }

  factory Poli.fromMap(Map<String, dynamic> map) {
    return Poli(
      id: map['id']?.toString(),
      namaPoli: map['namaPoli'] ?? '',
    );
  }
}
