import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Mahasiswa')),
      body: const Center(
        child: Text('Daftar Mahasiswa akan ditampilkan di sini'),
      ),
    );
  }
}
