import 'package:flutter/material.dart';
import '../repository/pago_repository.dart';
import '../models/pago_model.dart';

class VerPagosPage extends StatefulWidget {
  const VerPagosPage({super.key});

  @override
  State<VerPagosPage> createState() => _VerPagosPageState();
}

class _VerPagosPageState extends State<VerPagosPage> {

  final PagoRepository repository = PagoRepository();

  List<Payment> pagos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {

    try {

      final data = await repository.obtenerPagos();

      setState(() {
        pagos = data;
        cargando = false;
      });

    } catch (e) {

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
                  Text("Cargando pagos...")
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
                      SizedBox(height: 16),
                      Text(
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
                      child: ListTile(
                        leading: Icon(
                          Icons.payments_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text("Payment #${pago.id}"),
                        subtitle: Text("Amount \$${pago.amount}"),
                        trailing: Text(pago.status),
                      ),
                    );
                  },
                ),
    );
  }
}