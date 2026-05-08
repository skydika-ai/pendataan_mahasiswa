import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Kelompok'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAnggota('Andika', 'NIM: F55124083', Colors.indigo),
            _buildAnggota('Dareean Ahmad Raffi', 'NIM: F55124', Colors.teal),
            _buildAnggota('Abdul Haikal', 'NIM: F55124', Colors.deepOrange),
            _buildAnggota('Melin Oktafiani', 'NIM: F55124', Colors.purple),
            _buildAnggota(
              'Andi Besse Opu Tenri Sompa',
              'NIM: F55124',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnggota(String nama, String nim, Color warna) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: warna,
          child: Text(
            nama[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(nim),
      ),
    );
  }
}
