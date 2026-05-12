import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mahasiswa.dart';
import '../providers/mahasiswa_provider.dart';
import '../screens/item_card.dart';
import '../theme/app_theme.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showHero = false;
  bool _showStats = false;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MahasiswaProvider>().fetchMahasiswa());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _showHero = true);
      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted) setState(() => _showStats = true);
      });
      Future.delayed(const Duration(milliseconds: 220), () {
        if (mounted) setState(() => _showSearch = true);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Mahasiswa> _filteredMahasiswa(List<Mahasiswa> daftar) {
    if (_query.trim().isEmpty) return daftar;

    final keyword = _query.toLowerCase();
    return daftar.where((mahasiswa) {
      return mahasiswa.nama.toLowerCase().contains(keyword) ||
          mahasiswa.nim.toLowerCase().contains(keyword) ||
          mahasiswa.jurusan.toLowerCase().contains(keyword);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MahasiswaProvider>();
    final daftar = _filteredMahasiswa(provider.daftarMahasiswa);
    final totalMahasiswa = provider.daftarMahasiswa.length;
    final totalJurusan = provider.daftarMahasiswa
        .map((mahasiswa) => mahasiswa.jurusan)
        .toSet()
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MahasiswaProvider>().fetchMahasiswa(),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primary),
                  SizedBox(height: 14),
                  Text(
                    'Memuat data...',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            )
          : provider.errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          provider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: () =>
                      context.read<MahasiswaProvider>().fetchMahasiswa(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: [
                      AnimatedSlide(
                        offset: _showHero ? Offset.zero : const Offset(0, 0.04),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          opacity: _showHero ? 1 : 0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFFFFF), Color(0xFFF3F0EA)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: AppTheme.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 26,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: Container(
                                    width: 82,
                                    height: 82,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.primary.withOpacity(0.08),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 20,
                                  bottom: -24,
                                  child: Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.35),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primarySoft,
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                          child: const Icon(
                                            Icons.dashboard_outlined,
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dashboard Mahasiswa',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.textPrimary,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Ringkasan data yang bersih, tenang, dan mudah dibaca',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppTheme.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AnimatedSlide(
                                            offset: _showStats
                                                ? Offset.zero
                                                : const Offset(0, 0.08),
                                            duration: const Duration(
                                              milliseconds: 420,
                                            ),
                                            curve: Curves.easeOutCubic,
                                            child: AnimatedOpacity(
                                              opacity: _showStats ? 1 : 0,
                                              duration: const Duration(
                                                milliseconds: 420,
                                              ),
                                              child: _StatCard(
                                                label: 'Total data',
                                                value: '$totalMahasiswa',
                                                icon: Icons.people_outline,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: AnimatedSlide(
                                            offset: _showStats
                                                ? Offset.zero
                                                : const Offset(0, 0.08),
                                            duration: const Duration(
                                              milliseconds: 520,
                                            ),
                                            curve: Curves.easeOutCubic,
                                            child: AnimatedOpacity(
                                              opacity: _showStats ? 1 : 0,
                                              duration: const Duration(
                                                milliseconds: 520,
                                              ),
                                              child: _StatCard(
                                                label: 'Jurusan',
                                                value: '$totalJurusan',
                                                icon: Icons.school_outlined,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    AnimatedSlide(
                                      offset: _showSearch
                                          ? Offset.zero
                                          : const Offset(0, 0.06),
                                      duration: const Duration(milliseconds: 480),
                                      curve: Curves.easeOutCubic,
                                      child: AnimatedOpacity(
                                        opacity: _showSearch ? 1 : 0,
                                        duration:
                                            const Duration(milliseconds: 480),
                                        child: TextField(
                                          controller: _searchController,
                                          onChanged: (value) {
                                            setState(() => _query = value);
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Cari mahasiswa',
                                            hintText: 'Nama, NIM, atau jurusan',
                                            prefixIcon: const Icon(Icons.search_rounded),
                                            suffixIcon: _query.isEmpty
                                                ? null
                                                : IconButton(
                                                    onPressed: () {
                                                      _searchController.clear();
                                                      setState(() => _query = '');
                                                    },
                                                    icon: const Icon(Icons.close_rounded),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AnimatedOpacity(
                        opacity: _showHero ? 1 : 0,
                        duration: const Duration(milliseconds: 520),
                        curve: Curves.easeOutCubic,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.list_alt_rounded,
                                size: 18,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _query.isEmpty
                                    ? 'Menampilkan $totalMahasiswa mahasiswa'
                                    : 'Hasil pencarian: ${daftar.length} data',
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (daftar.isEmpty)
                        AnimatedOpacity(
                          opacity: _showHero ? 1 : 0,
                          duration: const Duration(milliseconds: 560),
                          curve: Curves.easeOutCubic,
                          child: Container(
                            margin: const EdgeInsets.only(top: 28),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 56,
                                  color: AppTheme.textSecondary,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Data tidak ditemukan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Coba kata kunci lain atau hapus pencarian.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...List.generate(
                          daftar.length,
                          (index) => TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 260 + (index * 60)),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 12 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: ItemCard(mahasiswa: daftar[index]),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 18),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
