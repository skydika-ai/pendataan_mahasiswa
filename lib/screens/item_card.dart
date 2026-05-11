import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';

class ItemCard extends StatelessWidget {
  final Mahasiswa mahasiswa;

  const ItemCard({super.key, required this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.pinkAccent,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 28,

          backgroundColor: Colors.purple,

          child: Text(
            mahasiswa.nama[0],

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        title: Text(
          mahasiswa.nama,

          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text('NIM : ${mahasiswa.nim}'),

              const SizedBox(height: 4),

              Text('Jurusan : ${mahasiswa.jurusan}'),
            ],
          ),
        ),
      ),
    );
  }
}
