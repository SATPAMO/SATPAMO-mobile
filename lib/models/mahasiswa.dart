class Mahasiswa {
  final String id;
  final String nim;
  final String name;
  final String jurusan;
  final int semester;

  Mahasiswa({
    required this.id,
    required this.nim,
    required this.name,
    required this.jurusan,
    required this.semester,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'] as String? ?? '',
      nim: json['nim'] as String? ?? '',
      name: json['name'] as String? ?? '',
      jurusan: json['jurusan'] as String? ?? '',
      semester: json['semester'] as int? ?? 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mahasiswa && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
