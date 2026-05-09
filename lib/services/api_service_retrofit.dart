import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/mahasiswa.dart';

part 'api_service_retrofit.g.dart';

@RestApi()
abstract class ApiServiceRetrofit {
  factory ApiServiceRetrofit(Dio dio, {String? baseUrl}) = _ApiServiceRetrofit;

  @GET('/mahasiswa')
  Future<List<Mahasiswa>> fetchMahasiswa();

  @POST('/mahasiswa')
  Future<void> addMahasiswa(@Body() Mahasiswa mahasiswa);
}
