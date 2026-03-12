import 'package:flutter/material.dart';
import '../models/metodo_pago_model.dart';
import '../services/pago_service.dart';

class RegistroPagoPage extends StatefulWidget {
  const RegistroPagoPage({super.key});

  @override
  State<RegistroPagoPage> createState() => _RegistroPagoPageState();
}

class _RegistroPagoPageState extends State<RegistroPagoPage> {
  final cuentaController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String? bancoSeleccionado;

  final List<String> bancos = [
    "Banco Pichincha",
    "DeUna",
    "Banco Guayaquil"
  ];

  final pagoService = PagoService();

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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Seleccione un banco";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: cuentaController,
                decoration: const InputDecoration(
                  labelText: "Número de cuenta",
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese número de cuenta";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese nombre";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: apellidoController,
                decoration: const InputDecoration(
                  labelText: "Apellido",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese apellido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: cedulaController,
                decoration: const InputDecoration(
                  labelText: "Cédula",
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese cédula";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Guardar"),
                onPressed: () async {
                  if (formKey.currentState!.validate() && bancoSeleccionado != null) {
                    final metodo = PaymentMethod(
                      bank: bancoSeleccionado!,
                      accountNumber: cuentaController.text,
                      firstName: nombreController.text,
                      lastName: apellidoController.text,
                      dni: cedulaController.text,
                    );

                    await pagoService.registrarMetodoPago(metodo);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Método de pago registrado"),
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}