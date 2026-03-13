import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Payment {
  final String id;
  final String banco;
  final String emisor;
  final double valor;
  final String fecha;

  Payment({
    required this.id,
    required this.banco,
    required this.emisor,
    required this.valor,
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

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    try {
      final data = await Supabase.instance.client
          .from('pagos')
          .select('id, banco, emisor, valor, fecha_mensaje')
          .order('id', ascending: false) as List<dynamic>? ?? [];

      setState(() {
        pagos = data.map((p) {
          return Payment(
            id: p['id']?.toString() ?? '--',
            banco: p['banco']?.toString() ?? '--',
            emisor: p['emisor']?.toString() ?? '--',
            valor: (p['valor'] != null)
                ? double.tryParse(p['valor'].toString()) ?? 0
                : 0,
            fecha: p['fecha_mensaje']?.toString() ?? '--',
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagos registrados"),
      ),
      body: cargando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Cargando pagos..."),
                ],
              ),
            )
          : pagos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        size: 60,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Sin pagos registrados",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pagos.length,
                  itemBuilder: (context, index) {
                    final pago = pagos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Banco: ${pago.banco}",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Emisor: ${pago.emisor}",
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Valor: \$${pago.valor.toStringAsFixed(2)}",
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Fecha: ${pago.fecha}",
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}