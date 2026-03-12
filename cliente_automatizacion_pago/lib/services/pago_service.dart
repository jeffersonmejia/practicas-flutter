import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/api/dio_client.dart';
import '../models/metodo_pago_model.dart';

class PagoService {

  final DioClient _client = DioClient();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Solo obtiene pagos de la API
  Future<Response> obtenerPagos() async {
    return await _client.get("/pagos");
  }

  // Registra un método de pago en Firebase
  Future<void> registrarMetodoPago(PaymentMethod metodo) async {
    try {
      await _firestore.collection("payment_methods").add(metodo.toJson());
      print("Payment method registered");
    } catch (e) {
      print("Error registering payment method: $e");
    }
  }
}
