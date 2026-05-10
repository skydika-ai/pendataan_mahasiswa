import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mahasiswa_provider.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _jurusanController = TextEditingController();

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _jurusanController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<MahasiswaProvider>();
    final berhasil = await provider.addMahasiswa(
      _nimController.text,
      _namaController.text,
      _jurusanController.text,
    );

    if (!mounted) return;

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data mahasiswa berhasil ditambahkan')),
      );
      _nimController.clear();
      _namaController.clear();
      _jurusanController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Gagal menyimpan data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<MahasiswaProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Mahasiswa'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'NIM wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jurusanController,
                decoration: const InputDecoration(
                  labelText: 'Jurusan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Jurusan wajib diisi' : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _simpanData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
