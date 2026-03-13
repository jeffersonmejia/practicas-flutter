import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';
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
  final String origen;

  Payment({
    required this.id,
    required this.createdAt,
    required this.ordenante,
    required this.beneficiario,
    required this.monto,
    required this.comprobante,
    required this.fecha,
    required this.origen,
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

  // Instancia independiente de SupabaseClient para la API "apiDeuna"
  final SupabaseClient deunaClient = SupabaseClient(
    'https://tdcogdgrpyqhznlmyhnf.supabase.co',
    'sb_publishable_RbZ6EgwHAZH39ISfsekCEA_wtsj1p1v',
  );

  @override
  void initState() {
    super.initState();
    user = fb_auth.FirebaseAuth.instance.currentUser;
    cargar();
    cargarDeuna();
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

      setState(() {
        pagos = data.map((p) => Payment(
          id: int.tryParse(p['id']?.toString() ?? '0') ?? 0,
          createdAt: p['created_at']?.toString() ?? '',
          ordenante: p['ordenante']?.toString() ?? '',
          beneficiario: p['beneficiario']?.toString() ?? '',
          monto: (p['monto'] != null) ? double.tryParse(p['monto'].toString()) ?? 0 : 0,
          comprobante: p['comprobante']?.toString() ?? '',
          fecha: p['fecha']?.toString() ?? '',
          origen: 'Banco Pichincha',
        )).toList();
        cargando = false;
      });
    } catch (e) {
      print("Excepción al cargar pagos: $e");
      setState(() {
        cargando = false;
      });
    }
  }

  Future<void> cargarDeuna() async {
    try {
      final data = await deunaClient
          .from('pagos_deuna')
          .select('id, created_at, ordenante, beneficiario, monto, comprobante, fecha')
          .order('id', ascending: false) as List<dynamic>? ?? [];

      setState(() {
        pagos.addAll(data.map((p) => Payment(
          id: int.tryParse(p['id']?.toString() ?? '0') ?? 0,
          createdAt: p['created_at']?.toString() ?? '',
          ordenante: p['ordenante']?.toString() ?? '',
          beneficiario: p['beneficiario']?.toString() ?? '',
          monto: (p['monto'] != null) ? double.tryParse(p['monto'].toString()) ?? 0 : 0,
          comprobante: p['comprobante']?.toString() ?? '',
          fecha: p['fecha']?.toString() ?? '',
          origen: 'Deuna',
        )).toList());
      });
    } catch (e) {
      print("Excepción al cargar pagos de Deuna: $e");
    }
  }

  Widget tagPago(String origen) {
    Color bg;
    Color text;
    if (origen == 'Deuna') {
      bg = const Color(0xFFE1BEE7);
      text = const Color(0xFF4A148C);
    } else {
      bg = const Color(0xFFFFF9C4);
      text = const Color(0xFF827717);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(origen, style: TextStyle(color: text, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color botonActualizarFondo = const Color(0xFFBBDEFB);
    final Color botonActualizarTexto = const Color(0xFF0D1B2A);
    final Color botonCerrarTexto = Colors.grey[700]!;

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
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cargar();
                            cargarDeuna();
                          },
                          icon: const Icon(Icons.refresh, size: 20),
                          label: const Text("Actualizar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: botonActualizarFondo,
                            foregroundColor: botonActualizarTexto,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: cerrarSesion,
                          icon: Icon(Icons.logout_outlined, size: 18, color: botonCerrarTexto),
                          label: Text(
                            "Cerrar sesión",
                            style: TextStyle(color: botonCerrarTexto, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
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
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                                  Text(
                                    "Beneficiario: ${pago.beneficiario}",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Comprobante: ${pago.comprobante}",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Fecha: ${pago.fecha}",
                                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                      ),
                                      tagPago(pago.origen),
                                    ],
                                  ),
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
