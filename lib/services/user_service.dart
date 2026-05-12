class User {
  final String name;
  final String username;
  final String password;

  User({
    required this.name,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'username': username,
    'password': password,
  };
}

class UserService {
  static final List<User> _registeredUsers = [
    User(name: 'Admin', username: 'admin', password: '1234'),
  ];

  /// Register user baru
  static Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String password,
  }) async {
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 800));

    // Cek apakah username sudah terdaftar
    final exists = _registeredUsers.any((u) => u.username == username);
    if (exists) {
      return {
        'success': false,
        'message': 'Username sudah terdaftar',
      };
    }

    // Tambah user baru
    _registeredUsers.add(
      User(name: name, username: username, password: password),
    );

    return {
      'success': true,
      'message': 'Pendaftaran berhasil',
    };
  }

  /// Validasi login
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 600));

    final user = _registeredUsers.firstWhere(
      (u) => u.username == username && u.password == password,
      orElse: () => User(name: '', username: '', password: ''),
    );

    if (user.username.isEmpty) {
      return {
        'success': false,
        'message': 'Username atau password salah',
        'user': null,
      };
    }

    return {
      'success': true,
      'message': 'Login berhasil',
      'user': user,
    };
  }

  /// Get semua user terdaftar (untuk debug)
  static List<User> getAllUsers() => _registeredUsers;
}
