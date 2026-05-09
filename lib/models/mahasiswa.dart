import 'package:json_annotation/json_annotation.dart';

part 'mahasiswa.g.dart';

@JsonSerializable()
class Mahasiswa {
  final String nim;
  final String nama;
  final String jurusan;

  Mahasiswa({required this.nim, required this.nama, required this.jurusan});

  factory Mahasiswa.fromJson(Map<String, dynamic> json) => _$MahasiswaFromJson(json);

  Map<String, dynamic> toJson() => _$MahasiswaToJson(this);
}
