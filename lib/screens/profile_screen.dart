import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mahasiswa.dart';
import '../providers/mahasiswa_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final Color avatarColor;

  const ProfileScreen({
    super.key,
    required this.mahasiswa,
    required this.avatarColor,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nimController;
  late final TextEditingController _namaController;
  late final TextEditingController _jurusanController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nimController = TextEditingController(text: widget.mahasiswa.nim);
    _namaController = TextEditingController(text: widget.mahasiswa.nama);
    _jurusanController = TextEditingController(text: widget.mahasiswa.jurusan);
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _jurusanController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    final id = widget.mahasiswa.id;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data ini tidak punya ID untuk diedit')),
      );
      return;
    }

    final provider = context.read<MahasiswaProvider>();
    final berhasil = await provider.updateMahasiswa(
      id,
      _nimController.text.trim(),
      _namaController.text.trim(),
      _jurusanController.text.trim(),
    );

    if (!mounted) return;

    if (berhasil) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal memperbarui profil'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<MahasiswaProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        actions: [
          TextButton.icon(
            onPressed: loading
                ? null
                : () => setState(() => _isEditing = !_isEditing),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            icon: Icon(_isEditing ? Icons.visibility_outlined : Icons.edit_outlined),
            label: Text(_isEditing ? 'Lihat' : 'Edit'),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF6F4F0), Color(0xFFE7EEEA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.22),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -16,
                      bottom: -18,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: widget.avatarColor,
                          child: Text(
                            widget.mahasiswa.nama[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isEditing ? 'Mode edit profil' : widget.mahasiswa.nama,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isEditing
                              ? 'Ubah data lalu simpan perubahan'
                              : 'Mahasiswa aktif',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (_isEditing) ...[
                _EditField(
                  controller: _namaController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _EditField(
                  controller: _nimController,
                  label: 'NIM',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 12),
                _EditField(
                  controller: _jurusanController,
                  label: 'Jurusan',
                  icon: Icons.school_outlined,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : _simpanPerubahan,
                    icon: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(loading ? 'Menyimpan...' : 'Simpan Perubahan'),
                  ),
                ),
              ] else ...[
                _ProfileDetailCard(
                  icon: Icons.badge_outlined,
                  label: 'NIM',
                  value: widget.mahasiswa.nim,
                ),
                const SizedBox(height: 12),
                _ProfileDetailCard(
                  icon: Icons.school_outlined,
                  label: 'Jurusan',
                  value: widget.mahasiswa.jurusan,
                ),
                const SizedBox(height: 12),
                _ProfileDetailCard(
                  icon: Icons.person_outline,
                  label: 'Nama Lengkap',
                  value: widget.mahasiswa.nama,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class _ProfileDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetailCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft.withOpacity(0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}