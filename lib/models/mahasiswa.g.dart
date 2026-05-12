// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mahasiswa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mahasiswa _$MahasiswaFromJson(Map<String, dynamic> json) => Mahasiswa(
      id: json['id'] as String?,
      nim: json['nim'] as String,
      nama: json['nama'] as String,
      jurusan: json['jurusan'] as String,
    );

Map<String, dynamic> _$MahasiswaToJson(Mahasiswa instance) => <String, dynamic>{
      'id': instance.id,
      'nim': instance.nim,
      'nama': instance.nama,
      'jurusan': instance.jurusan,
    };
