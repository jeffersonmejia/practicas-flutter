import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/metodo_pago_model.dart';

class MetodoPagoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registra un método de pago
  Future<void> registrarMetodoPago(PaymentMethod metodo) async {
    try {
      await _firestore.collection("payment_methods").add(metodo.toJson());
      print("Payment method registered");
    } catch (e) {
      print("Error registering payment method: $e");
    }
  }

  // Obtiene todos los métodos de pago
  Future<List<PaymentMethod>> obtenerMetodosPago() async {
    try {
      final querySnapshot =
          await _firestore.collection("payment_methods").get();
      return querySnapshot.docs
          .map((doc) => PaymentMethod.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Error fetching payment methods: $e");
      return [];
    }
  }

  // Actualiza un método de pago existente
  Future<void> actualizarMetodoPago(String id, PaymentMethod metodo) async {
    try {
      await _firestore
          .collection("payment_methods")
          .doc(id)
          .update(metodo.toJson());
      print("Payment method updated");
    } catch (e) {
      print("Error updating payment method: $e");
    }
  }
}