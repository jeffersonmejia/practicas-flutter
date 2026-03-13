import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

class Payment {
  final int id;
  final String createdAt;
  final String ordenante;
  final String beneficiario;
  final double monto;
  final String comprobante;
  final String fecha;

  Payment({
    required this.id,
    required this.createdAt,
    required this.ordenante,
    required this.beneficiario,
    required this.monto,
    required this.comprobante,
    required this.fecha,
  });
}

class VerPagosPage extends StatefulWidget {
  const VerPagosPage({super.key});

  @override
  State<VerPagosPage> createState() => _VerPagosPageState();
}

class _VerPagosPageState extends State<VerPagosPage> {
  List<Payment> pagos = [];
  bool cargando = true;
  fb_auth.User? user;

  @override
  void initState() {
    super.initState();
    user = fb_auth.FirebaseAuth.instance.currentUser;
    cargar();
  }

  Future<void> cerrarSesion() async {
    await GoogleSignIn().signOut();
    await fb_auth.FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> cargar() async {
    setState(() {
      cargando = true;
    });
    try {
      final data = await Supabase.instance.client
          .from('pagos_verificados')
          .select('id, created_at, ordenante, beneficiario, monto, comprobante, fecha')
          .order('id', ascending: false) as List<dynamic>? ?? [];

      print("Datos recibidos de Supabase:");
      print(data);

      setState(() {
        pagos = data.map((p) {
          return Payment(
            id: int.tryParse(p['id']?.toString() ?? '0') ?? 0,
            createdAt: p['created_at']?.toString() ?? '',
            ordenante: p['ordenante']?.toString() ?? '',
            beneficiario: p['beneficiario']?.toString() ?? '',
            monto: (p['monto'] != null) ? double.tryParse(p['monto'].toString()) ?? 0 : 0,
            comprobante: p['comprobante']?.toString() ?? '',
            fecha: p['fecha']?.toString() ?? '',
          );
        }).toList();
        cargando = false;
      });
    } catch (e) {
      print("Excepción al cargar pagos: $e");
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color botonActualizarFondo = const Color(0xFFBBDEFB); // azul suave
    final Color botonActualizarTexto = const Color(0xFF0D1B2A); // azul tirando a negro
    final Color botonCerrarTexto = Colors.grey[700]!; // gris suave

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Pagos registrados"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          if (user != null)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: user!.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                    child: user!.photoURL == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user!.displayName ?? "Usuario",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user!.email ?? "",
                    style: TextStyle(color: Colors.grey[700], fontSize: 17),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 3, // Mantengo actualizar amplio
                        child: ElevatedButton.icon(
                          onPressed: cargar,
                          icon: const Icon(Icons.refresh, size: 20),
                          label: const Text("Actualizar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: botonActualizarFondo,
                            foregroundColor: botonActualizarTexto,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2, // Mayor espacio horizontal para cerrar sesión
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          child: OutlinedButton.icon(
                            onPressed: cerrarSesion,
                            icon: Icon(Icons.logout_outlined, size: 18, color: botonCerrarTexto),
                            label: Text(
                              "Cerrar sesión",
                              style: TextStyle(color: botonCerrarTexto, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              side: BorderSide(color: Colors.grey.withOpacity(0.2)), // borde muy sutil
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : pagos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.payments_outlined, size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            const Text(
                              "Sin pagos registrados",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: pagos.length,
                        itemBuilder: (context, index) {
                          final pago = pagos[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.account_circle, color: Colors.grey[500]),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          pago.ordenante,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        "\$${pago.monto.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.green[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Beneficiario: ${pago.beneficiario}",
                                      style: TextStyle(color: Colors.grey[700])),
                                  const SizedBox(height: 4),
                                  Text("Comprobante: ${pago.comprobante}",
                                      style: TextStyle(color: Colors.grey[700])),
                                  const SizedBox(height: 4),
                                  Text("Fecha: ${pago.fecha}",
                                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
