import 'package:dio/dio.dart';
import '../core/api/dio_client.dart';

class PagoService {
  final DioClient _client = DioClient();

  // Obtiene pagos desde la API
  Future<Response> obtenerPagos() async {
    return await _client.get("/pagos");
  }
}