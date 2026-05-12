import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mahasiswa_provider.dart';
import '../screens/item_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MahasiswaProvider>().fetchMahasiswa());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MahasiswaProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text(
          'Data Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MahasiswaProvider>().fetchMahasiswa(),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF3F51B5)),
                  SizedBox(height: 14),
                  Text('Memuat data...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (provider.daftarMahasiswa.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada data mahasiswa',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: const Color(0xFF3F51B5).withOpacity(0.08),
                child: Text(
                  'Total: ${provider.daftarMahasiswa.length} mahasiswa',
                  style: const TextStyle(
                    color: Color(0xFF3F51B5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xFF3F51B5),
                  onRefresh: () =>
                      context.read<MahasiswaProvider>().fetchMahasiswa(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: provider.daftarMahasiswa.length,
                    itemBuilder: (context, index) =>
                        ItemCard(mahasiswa: provider.daftarMahasiswa[index]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
