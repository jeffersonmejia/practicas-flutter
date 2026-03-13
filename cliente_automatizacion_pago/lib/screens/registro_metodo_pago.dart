import 'package:flutter/material.dart';
import '../models/metodo_pago_model.dart';
import '../services/metodo_pago_service.dart';

class RegistroPagoPage extends StatefulWidget {
  const RegistroPagoPage({super.key});

  @override
  State<RegistroPagoPage> createState() => _RegistroPagoPageState();
}

class _RegistroPagoPageState extends State<RegistroPagoPage> {

  final cuentaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? bancoSeleccionado;

  final List<String> bancos = [
    "Banco Pichincha",
    "DeUna"
  ];

  final metodoPagoService = MetodoPagoService();

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar método de pago"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: ListView(
            children: [

              Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 30),

              DropdownButtonFormField<String>(
                value: bancoSeleccionado,
                decoration: const InputDecoration(
                  labelText: "Banco",
                  prefixIcon: Icon(Icons.account_balance),
                ),
                items: bancos.map((banco) {
                  return DropdownMenuItem(
                    value: banco,
                    child: Text(banco),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    bancoSeleccionado = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: cuentaController,
                decoration: const InputDecoration(
                  labelText: "Número de cuenta",
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}