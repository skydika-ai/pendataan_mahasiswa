import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mahasiswa_provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil data saat pertama kali masuk ke halaman list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MahasiswaProvider>().fetchMahasiswa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MahasiswaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('List Mahasiswa')),
      body: RefreshIndicator(
        onRefresh: provider.fetchMahasiswa,
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(provider.errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: provider.fetchMahasiswa,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : provider.daftarMahasiswa.isEmpty
                    ? const Center(child: Text('Belum ada data mahasiswa'))
                    : ListView.builder(
                        itemCount: provider.daftarMahasiswa.length,
                        itemBuilder: (context, index) {
                          final mahasiswa = provider.daftarMahasiswa[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(mahasiswa.nama),
                              subtitle: Text('${mahasiswa.nim} - ${mahasiswa.jurusan}'),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
