import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';

class MahasiswaProvider extends ChangeNotifier {
  final ApiService _apiService;

  MahasiswaProvider(this._apiService);

  List<Mahasiswa> _daftarMahasiswa = [];
  List<Mahasiswa> get daftarMahasiswa => _daftarMahasiswa;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMahasiswa() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _daftarMahasiswa = await _apiService.fetchMahasiswa();
    } catch (e) {
      _errorMessage = 'Gagal mengambil data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMahasiswa(String nim, String nama, String jurusan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final mahasiswaBaru = Mahasiswa(nim: nim, nama: nama, jurusan: jurusan);
      final berhasil = await _apiService.addMahasiswa(mahasiswaBaru);
      if (berhasil) {
        await fetchMahasiswa();
      }
      return berhasil;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan data: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ← deleteMahasiswa di DALAM class
  Future<bool> deleteMahasiswa(String id) async {
    try {
      final berhasil = await _apiService.deleteMahasiswa(id);
      if (berhasil) {
        await fetchMahasiswa();
      }
      return berhasil;
    } catch (e) {
      _errorMessage = 'Gagal menghapus data: $e';
      notifyListeners();
      return false;
    }
  }
}
