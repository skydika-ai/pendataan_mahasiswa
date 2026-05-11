import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';
import '../screens/item_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Mahasiswa>> futureMahasiswa;

  @override
  void initState() {
    super.initState();

    // dummy data sementara
    futureMahasiswa = Future.delayed(
      const Duration(seconds: 2),

      () => [
        Mahasiswa(
          nim: 'F55124001',
          nama: 'Melin Oktafiani',
          jurusan: 'Teknik Informatika',
        ),

        Mahasiswa(
          nim: 'F55124002',
          nama: 'Andika',
          jurusan: 'Sistem Informasi',
        ),

        Mahasiswa(
          nim: 'F55124003',
          nama: 'Abdul Haikal',
          jurusan: 'Teknik Informatika',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text('List Mahasiswa'),

        backgroundColor: Colors.pink,

        foregroundColor: Colors.white,

        centerTitle: true,
      ),

      body: FutureBuilder<List<Mahasiswa>>(
        future: futureMahasiswa,

        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  CircularProgressIndicator(),

                  SizedBox(height: 15),

                  Text('Memuat data mahasiswa...'),
                ],
              ),
            );
          }

          // error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // data kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),

                  SizedBox(height: 10),

                  Text('Data mahasiswa kosong', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          final mahasiswa = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },

            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 10),

              itemCount: mahasiswa.length,

              itemBuilder: (context, index) {
                return ItemCard(mahasiswa: mahasiswa[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
