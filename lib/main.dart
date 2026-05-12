import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_navigation.dart';
import 'screens/login_screen.dart'; // ← tambah import ini
import 'services/api_service.dart';
import 'providers/mahasiswa_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MahasiswaProvider(
        ApiService(baseUrl: 'https://6a0357e12afe8349b4b517b7.mockapi.io'),
      ),
      child: MaterialApp(
        title: 'Pendataan Mahasiswa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: true,
        ),
        home: const LoginScreen(), // ← ganti ini
      ),
    );
  }
}
