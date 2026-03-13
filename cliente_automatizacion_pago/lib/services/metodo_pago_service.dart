import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/metodo_pago_model.dart';

class MetodoPagoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registrarMetodoPago(PaymentMethod metodo) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

      final metodoFinal = PaymentMethod(
        bank: metodo.bank,
        accountNumber: metodo.accountNumber,
        email: user.email ?? "",
        names: user.displayName ?? "Usuario",
      );

      await _firestore
          .collection("payment_methods")
          .add(metodoFinal.toJson());

      print("Payment method registered");
    } catch (e) {
      print("Error registering payment method: $e");
    }
  }

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