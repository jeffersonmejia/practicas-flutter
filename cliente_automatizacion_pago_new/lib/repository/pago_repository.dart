import '../models/pago_model.dart';
import '../services/pago_service.dart';

class PagoRepository {

  final PagoService service = PagoService();

  Future<List<Payment>> obtenerPagos() async {

    final response = await service.obtenerPagos();

    final List<dynamic> data = response.data;

    return data.map((e) => Payment.fromJson(e)).toList();
  }
}