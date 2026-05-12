import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/mahasiswa.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  /// Fetch list of mahasiswa from server.
  ///
  /// Expects the endpoint `GET {baseUrl}/mahasiswa` to return either a JSON
  /// array of mahasiswa objects or an object containing a `data` array.
  Future<List<Mahasiswa>> fetchMahasiswa() async {
    final uri = Uri.parse('$baseUrl/mahasiswa');
    final resp = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      if (body is List) {
        return body
            .map((e) => Mahasiswa.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (body is Map && body['data'] is List) {
        return (body['data'] as List)
            .map((e) => Mahasiswa.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to fetch mahasiswa: ${resp.statusCode}');
    }
  }

  /// Add a new mahasiswa by sending `POST {baseUrl}/mahasiswa` with JSON body.
  /// Returns true when server responds with 200 or 201.
  Future<bool> addMahasiswa(Mahasiswa m) async {
    final uri = Uri.parse('$baseUrl/mahasiswa');
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(m.toJson()),
    );
    return resp.statusCode == 200 || resp.statusCode == 201;
  }

  Future<bool> deleteMahasiswa(String id) async {
    final uri = Uri.parse('$baseUrl/mahasiswa/$id');
    final resp = await _client.delete(uri);
    return resp.statusCode == 200;
  }
}
