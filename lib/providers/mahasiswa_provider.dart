import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';

// ============================================================
// FILE   : lib/providers/mahasiswa_provider.dart
// DIBUAT : Abdul Haikal
// TUGAS  : Pengganti ViewModel — menyambungkan API Dareean
//          ke tampilan Melin (list) dan Andika (form input)
// ============================================================

class MahasiswaProvider extends ChangeNotifier {
  final ApiService _apiService;

  MahasiswaProvider(this._apiService);

  // Daftar mahasiswa yang ditampilkan Melin
  List<Mahasiswa> _daftarMahasiswa = [];
  List<Mahasiswa> get daftarMahasiswa => _daftarMahasiswa;

  // Status loading (untuk FutureBuilder / CircularProgressIndicator Melin)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Pesan error jika gagal
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ----------------------------------------------------------
  // FETCH: ambil semua data mahasiswa dari API Dareean
  // Dipanggil oleh Melin di list_screen.dart
  // ----------------------------------------------------------
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
      notifyListeners(); // beritahu Melin untuk update tampilan
    }
  }

  // ----------------------------------------------------------
  // ADD: kirim data baru dari form Andika ke API Dareean
  // Dipanggil oleh input_screen.dart saat tombol Simpan ditekan
  // ----------------------------------------------------------
  Future<bool> addMahasiswa(String nim, String nama, String jurusan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final mahasiswaBaru = Mahasiswa(nim: nim, nama: nama, jurusan: jurusan);
      final berhasil = await _apiService.addMahasiswa(mahasiswaBaru);

      if (berhasil) {
        await fetchMahasiswa(); // refresh list Melin otomatis
      }
      return berhasil;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan data: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
